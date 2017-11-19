require('pg')
require_relative('../db/sql_runner.rb')

class Ticket

    attr_accessor :screening_id, :customer_id
    attr_reader :id

  def save()
    sql = 'INSERT INTO tickets (customer_id, screening_id) VALUES ($1, $2) Returning id'
    values = [@customer_id, @screening_id]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def initialize(options)
    @customer_id = options['customer_id'].to_i
    @screening_id = options['screening_id'].to_i
    @id = options['id'].to_i if options['id']
  end

  def self.all()
  sql = "SELECT * FROM tickets"
  tickets = SqlRunner.run(sql)
  return tickets.map {|ticket| Ticket.new(ticket)}
  end

  def screening()
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [@screening_id]
    result = SqlRunner.run(sql, values)
    return Screening.new(result[0])
  end

  def film_title()
  sql = 'SELECT films.title FROM films INNER JOIN screenings on screenings.film_id = films.id INNER JOIN tickets ON screenings.id = tickets.screening_id WHERE tickets.id = $1'
  values = [@id]
  return SqlRunner.run(sql, values)[0]['title']
  end

  def customer()
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@customer_id]
    result = SqlRunner.run(sql, values)
    return Customer.new(result[0])
  end

  def self.delete_all()
    sql = 'DELETE FROM tickets'
    SqlRunner.run(sql)
  end

  def update
    sql = 'UPDATE tickets SET customer_id = $1, screening_id = $2 WHERE id = $3'
    values = [@customer_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

end
