# frozen_string_literal: true

RSpec.describe PgSqlCaller::Base do

  describe '.select_values' do
    subject do
      described_class.select_values(sql, *sql_bindings)
    end

    let!(:dep) do
      dep = Department.create! name: 'Tech'
    end
    let!(:employees) do
      Employee.create! [
                         { name: 'John Doe', department_id: dep.id },
                         { name: 'Jane Doe', department_id: dep.id }
                       ]
    end
    before do
      dep2 = Department.create! name: 'Sales'
      Employee.create! name: 'Jake Doe', department_id: dep2.id
    end

    let(:sql) { 'select name from employees where department_id = ?' }
    let(:sql_bindings) {  [dep.id] }

    it 'return correct values' do
      expect(subject).to match_array employees.map(&:name)
    end
  end

  describe '.transaction_open?' do
    subject do
      described_class.transaction_open?
    end

    it 'returns false' do
      is_expected.to eq(false)
    end

    context 'when within ApplicationRecord.transaction' do
      it 'returns true' do
        ApplicationRecord.transaction { is_expected.to eq(false) }
      end
    end

    context 'when within PgSqlCaller::Base.transaction' do
      it 'returns true' do
        described_class.transaction { is_expected.to eq(true) }
      end
    end

  end

end
