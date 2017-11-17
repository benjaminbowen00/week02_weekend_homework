require('pg')
require_relative('../db/sql_runner.rb')

class Ticket

    attr_reader :film_id, :customer_id, :id

  def save()
    sql = 'INSERT INTO tickets (customer_id, film_id) VALUES ($1, $2) Returning id'
    values = [@customer_id, @film_id]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def initialize(options)
    @film_id = options['film_id'].to_i
    @customer_id = options['customer_id'].to_i
    @id = options['id'].to_i if options['id']
  end

  def film
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@film_id]
    result = SqlRunner.run(sql, values)
    return Film.new(result[0])
  end

  def customer
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@customer_id]
    result = SqlRunner.run(sql, values)
    return Customer.new(result[0])
  end

  def self.delete_all()
    sql = 'DELETE FROM tickets'
    SqlRunner.run(sql)
  end

end
