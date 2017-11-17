require('pg')
require_relative('../db/sql_runner.rb')


class Customer
  attr_accessor :name, :funds

  def initialize(options)
    @name = options['name']
    @funds = options['funds']
    @id = options['id'].to_i if options['id']
  end

  def save()
    sql = 'INSERT INTO customers (name, funds) VALUES ($1, $2) Returning id'
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def self.delete_all()
    sql = 'DELETE FROM customers'
    SqlRunner.run(sql)
  end

  def delete()
    sql = 'DELETE FROM customers WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update_name(name)
    sql = 'UPDATE customers SET name = $1 WHERE id = $2'
    values = [name, @id]
    SqlRunner.run(sql, values)
    self.name = name
  end

  def update_funds(amount)
    sql = 'UPDATE customers SET funds = $1 WHERE id = $2'
    values = [amount, @id]
    SqlRunner.run(sql, values)
    self.funds = amount
  end
end
