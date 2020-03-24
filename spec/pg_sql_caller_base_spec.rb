# frozen_string_literal: true

RSpec.describe PgSqlCaller::Base do
  it 'performs select_values correctly' do
    dep = Department.create! name: 'Tech'
    employees = Employee.create! [
                                     { name: 'John Doe', department_id: dep.id },
                                     { name: 'Jane Doe', department_id: dep.id }
                                 ]

    dep2 = Department.create! name: 'Sales'
    Employee.create! name: 'Jake Doe', department_id: dep2.id

    expect(
        PgSqlCaller::Base.select_values('select name from employees where department_id = ?', dep.id)
    ).to match_array(
             employees.map(&:name)
         )
  end

  it 'performs transaction_open? correctly' do
    expect(PgSqlCaller::Base.transaction_open?).to eq(false)
    PgSqlCaller::Base.transaction do
      expect(PgSqlCaller::Base.transaction_open?).to eq(true)
    end
    ApplicationRecord.transaction do
      expect(PgSqlCaller::Base.transaction_open?).to eq(true)
    end
  end
end
