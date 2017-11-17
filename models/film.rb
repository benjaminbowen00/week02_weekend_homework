require('pg')
require_relative('../db/sql_runner.rb')

class Film
  attr_accessor :title, :price

  def initialize(options)
    @title = options['title']
    @price = options['price']
    @id = options['id'].to_i if options['id']
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


end
