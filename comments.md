#Better to think of the save function as a create - e.g. if you change an attribute and then save it, this will create a new row in the table - you need to update

#WHen we do this:   
Customer method:
def buy_ticket(film)
    hash = {'customer_id'=> @id, 'film_id'=> film.id}
    ticket = Ticket.new(hash)
    ticket.save
    @funds -= film.price
    self.update
    return nil
  end

We create the ticket object but it doesn't have a name - how can we do anything on this e.g. update in the console? - Same problem as before about a different object being created if we use the info from the database

#Hadn't written the screenings delete_all class method and then got errors when trying to do the film delete all in console. If you have cascade delete then you don't need the delete_all on the 'many' table as this is deleted when the 'one' table is deleted
Remember to do cascade delete

#Need to have a screening_id on the ticket (rather than the film_id? This gives the film_id but also more information. - otherwise the screening info is lost once the buy_ticket method is run on a customer.
  I decided to go with this so that I could count the number of tickets for a screening.

#Wanted to do this to count the number of tickets for a film:
SELECT title, COUNT(title) FROM tickets INNER JOIN screenings on tickets.screening_id = screenings.id INNER JOIN films on screenings.film_id = films.id GROUP BY title

but had the problem of not being able to count if you join on something that is null - nobody bought a ticket for film

#Had to remember to update the customer after changing their funds in the buy ticket method

#Couldn't do a MAX(COUNT(...)) in one query so did a sort descending and limited results to 1

#In the Screening.most_popular, it doesn't matter that we are getting back additional info (the count) in the hash returned from postgres to form the screening object
def self.most_popular()
  sql = "SELECT screenings.*, COUNT(1) FROM tickets INNER JOIN screenings ON tickets.screening_id = screenings.id GROUP BY screenings.id ORDER BY count DESC LIMIT 1"
  screening = SqlRunner.run(sql).first
  return Screening.new(screening)
end
