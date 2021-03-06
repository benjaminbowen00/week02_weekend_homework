require('pg')
require_relative('../db/sql_runner.rb')
require_relative('./ticket.rb')
require_relative('./film.rb')
require_relative('./ticket.rb')
require_relative('./screening.rb')



class Customer
  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @name = options['name']
    @funds = options['funds']
    @id = options['id'].to_i if options['id']
  end

  def buy_ticket(screening)
    if screening.empty_seats > 0
      ticket_hash = {'customer_id'=> @id, 'screening_id'=> screening.id}
      ticket = Ticket.new(ticket_hash)
      ticket.save
      sql = "SELECT films.price FROM films WHERE films.id = $1"
      values = [screening.film_id]
      price = SqlRunner.run(sql, values).first['price'].to_i
      @funds -= price
      self.update
      screening.empty_seats -= 1
      screening.update
      return nil
    else
      return "No seats left"
    end
  end

  #Did buy ticket based before I built the screening class:
  # def buy_ticket(film)
  #   hash = {'customer_id'=> @id, 'film_id'=> film.id}
  #   ticket = Ticket.new(hash)
  #   ticket.save
  #   @funds -= film.price
  #   return nil
  # end

  def self.all()
  sql = "SELECT * FROM customers"
  customers = SqlRunner.run(sql)
  return customers.map {|customer| Customer.new(customer)}
  end

  def number_of_tickets()
    sql = 'SELECT COUNT(customer_id) FROM tickets WHERE customer_id = $1'
    values = [@id]
    return SqlRunner.run(sql, values).first['count'].to_i
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

  #update in general after using setters in ruby

  def update
    sql = 'UPDATE customers SET name = $1, funds = $2 WHERE id = $3'
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  #updates which go to the data base first
  # def update_name(name)
  #   sql = 'UPDATE customers SET name = $1 WHERE id = $2'
  #   values = [name, @id]
  #   SqlRunner.run(sql, values)
  #   self.name = name
  # end
  #
  # def update_funds(amount)
  #   sql = 'UPDATE customers SET funds = $1 WHERE id = $2'
  #   values = [amount, @id]
  #   SqlRunner.run(sql, values)
  #   self.funds = amount
  # end

  def show_films
    sql = "SELECT films.* FROM films INNER JOIN screenings ON screenings.film_id = films.id INNER JOIN tickets on screenings.id = tickets.screening_id INNER JOIN customers on customers.id = tickets.customer_id WHERE customers.id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map {|film| Film.new(film)}
  end

end
