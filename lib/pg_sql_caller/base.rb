# frozen_string_literal: true

require 'singleton'
require 'forwardable'
require 'active_support/core_ext/class/attribute'

module PgSqlCaller
  class Base
    include Singleton
    extend Forwardable
    extend SingleForwardable

    CONNECTION_SQL_METHODS = [
        :select_value,
        :select_values,
        :execute,
        :select_all,
        :select_rows,
        :select_row
    ].freeze

    class_attribute :_model_class, instance_writer: false

    class << self
      # @names [Array] method names
      def delegate(*names, **options)
        raise ArgumentError, 'provide at least one method name' if names.empty?

        target = options.fetch(:to)
        type = options.fetch(:type, :instance)
        raise ArgumentError, ':type can be :single or :instance' unless [:single, :instance].include?(type)

        if type == :instance
          instance_delegate names => target
        else
          single_delegate names => target
        end
      end

      def define_sql_methods(*names)
        names.each do |name|
          define_method(name) do |sql, *bindings|
            sql = sanitize_sql_array(sql, *bindings) if bindings.any?
            connection.send(name, sql)
          end
        end
      end

      # @param klass [Class<ActiveRecord::Base>, String] class or class name
      def model_class(klass)
        self._model_class = klass
      end
    end

    delegate(
        *CONNECTION_SQL_METHODS,
        :transaction_open?,
        :select_all_serialized,
        :transaction,
        :explain_analyze,
        :typecast_array,
        :sanitize_sql_array,
        :current_database,
        *CONNECTION_SQL_METHODS,
        to: :instance,
        type: :single
    )

    define_sql_methods(*CONNECTION_SQL_METHODS)

    delegate :transaction_open?, to: :connection

    def select_all_serialized(sql, *bindings)
      result = select_all(sql, *bindings)
      result.map { |row| row.map { |k, v| [k.to_sym, result.column_types[k].deserialize(v)] }.to_h }
    end

    def transaction
      raise ArgumentError, 'block must be given' unless block_given?

      connection.transaction { yield }
    end

    def explain_analyze(sql)
      result = select_values("EXPLAIN ANALYZE #{sql}")
      ['QUERY_PLAN', *result].join("\n")
    end

    def typecast_array(values, type:)
      type = ActiveRecord::Type.lookup(type, array: true)
      data = type.serialize(values)
      data.encoder.encode(data.values)
    end

    def sanitize_sql_array(sql, *bindings)
      model_class.send :sanitize_sql_array, bindings.unshift(sql)
    end

    def current_database_name
      select_value('SELECT current_database();')
    end

    private

    delegate :connection, to: :model_class

    def model_class
      return @model_class if defined?(@model_class)

      raise NotImplementedError, "define model_class in #{self.class}" if _model_class.nil?

      @model_class = _model_class.is_a?(String) ? _model_class.constantize : _model_class
    end
  end
end
