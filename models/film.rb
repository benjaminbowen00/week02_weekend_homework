require('pg')
require_relative('../db/sql_runner.rb')
require_relative('./customer.rb')
require_relative('./ticket.rb')
require_relative('./screening.rb')



class Film
  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @title = options['title']
    @price = options['price']
    @id = options['id'].to_i if options['id']
  end

  def self.most_popular_film_title
  sql = 'SELECT films.title, COUNT(films.title) FROM tickets INNER JOIN screenings on tickets.screening_id = screenings.id INNER JOIN films on screenings.film_id = films.id GROUP BY title ORDER BY COUNT(films.title) DESC LIMIT 1'
  return SqlRunner.run(sql)[0]['title']
  end

  def most_popular_time
  sql = 'SELECT screenings.start_time, COUNT(tickets.screening_id) FROM tickets INNER JOIN screenings ON tickets.screening_id = screenings.id INNER JOIN films on screenings.film_id = films.id WHERE films.id = $1 GROUP BY screenings.start_time'
  values = [@id]
  return SqlRunner.run(sql, values)[0]['start_time']
  end

  #This took me a lot of time and following stack overfolow examples after I switched to tickets showing the screening_id - because if there were no tickets for film then there were no results from the join and hence no table to count on.
  def number_of_customers()
    sql = 'SELECT title, SUM(CASE WHEN customer_id is NULL then 0 else 1 END) FROM tickets FULL OUTER JOIN screenings on tickets.screening_id = screenings.id FULL OUTER JOIN films on screenings.film_id = films.id WHERE films.id = $1 group by films.title'
    values = [@id]
    result = SqlRunner.run(sql, values)[0]['sum'].to_i
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

  def update()
    sql = 'UPDATE films SET (title, price) = ($1, $2) WHERE id = $3'
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  # def update_title(title)
  #   sql = 'UPDATE films SET title = $1 WHERE id = $2'
  #   values = [title, @id]
  #   SqlRunner.run(sql, values)
  #   self.title = title
  # end
  #
  # def update_price(amount)
  #   sql = 'UPDATE films SET price = $1 WHERE id = $2'
  #   values = [amount, @id]
  #   SqlRunner.run(sql, values)
  #   self.price = amount
  # end

  def show_customers
    sql = "SELECT customers.* FROM films INNER JOIN screenings ON films.id = screenings.film_id INNER JOIN tickets ON screenings.id = tickets.screening_id INNER JOIN customers on tickets.customer_id = customers.id WHERE films.id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map {|customer| Customer.new(customer)}
  end



end
