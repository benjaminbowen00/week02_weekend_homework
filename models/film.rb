require('pg')
require_relative('../db/sql_runner.rb')
require_relative('./customer.rb')
require_relative('./ticket.rb')


class Film
  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @title = options['title']
    @price = options['price']
    @id = options['id'].to_i if options['id']
  end

  def number_of_customers()
    sql = 'SELECT COUNT(film_id) FROM tickets WHERE film_id = $1'
    values = [@id]
    return SqlRunner.run(sql, values).first['count'].to_i
  end

  def self.all()
  sql = "SELECT * FROM films"
  films = SqlRunner.run(sql)
  return films.map {|film| Film.new(film)}
  end

  def save()
    sql = 'INSERT INTO films (title, price) VALUES ($1, $2) Returning id'
    values = [@title, @price]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def self.delete_all()
    sql = 'DELETE FROM films'
    SqlRunner.run(sql)
  end

  def delete()
    sql = 'DELETE FROM films WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update
    sql = 'UPDATE films SET title = $1,  price = $2 WHERE id = $3'
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def update_title(title)
    sql = 'UPDATE films SET title = $1 WHERE id = $2'
    values = [title, @id]
    SqlRunner.run(sql, values)
    self.title = title
  end

  def update_price(amount)
    sql = 'UPDATE films SET price = $1 WHERE id = $2'
    values = [amount, @id]
    SqlRunner.run(sql, values)
    self.price = amount
  end

  def show_customers
    sql = "SELECT customers.* FROM films INNER JOIN tickets ON films.id = tickets.film_id INNER JOIN customers ON tickets.customer_id = customers.id WHERE films.id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map {|customer| Customer.new(customer)}
  end



end
