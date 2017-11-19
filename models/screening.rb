require('pg')
require_relative('../db/sql_runner.rb')
require_relative('./ticket.rb')

class Screening
  attr_reader :id
  attr_accessor :film_id, :start_time, :empty_seats

  def initialize(options)
    @film_id = options['film_id']
    @start_time = options['start_time']
    @empty_seats = options['empty_seats']
    @id = options['id'].to_i if options['id']
  end


  def save()
    sql = 'INSERT INTO screenings (film_id, start_time, empty_seats) VALUES ($1, $2, $3) Returning id'
    values = [@film_id, @start_time, @empty_seats]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def update()
    sql = 'UPDATE screenings SET (start_time, empty_seats) = ($1,$2) WHERE id = $3'
    values = [@start_time, @empty_seats, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = 'DELETE FROM screenings'
    SqlRunner.run(sql)
  end

  def self.all()
  sql = "SELECT * FROM screenings"
  screenings = SqlRunner.run(sql)
  return screenings.map {|screening| Screening.new(screening)}
  end

  def self.most_popular()
    sql = "SELECT screenings.*, COUNT(1) FROM tickets INNER JOIN screenings ON tickets.screening_id = screenings.id GROUP BY screenings.id ORDER BY count DESC LIMIT 1"
    screening = SqlRunner.run(sql).first
    return Screening.new(screening)
  end

end
