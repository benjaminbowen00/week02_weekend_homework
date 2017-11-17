require('pg')
require_relative('../db/sql_runner.rb')

class Ticket

  def initialize(customer, film)
    @film_id = customer['id'].to_i
    @customer_id = film['id'].to_i
    @id =

  end

end
