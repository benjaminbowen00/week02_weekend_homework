#Better to think of the save function as a create - e.g. if you change an attribute and then save it, this will create a new row in the table - you need to update

#WHen we do this:   
Customer method:
def buy_ticket(film)
    hash = {'customer_id'=> @id, 'film_id'=> film.id}
    ticket = Ticket.new(hash)
    ticket.save
    @funds -= film.price
  end

We create the ticket object but it doesn't have a name - how can we do anything on this e.g. update in the console? - Same problem as before about a different object being created if we use the info from the database

#Hadn't written the screenings delete_all class method and then got errors when trying to do the film delete all in console. If you have cascade delete then you don't need the delete_all on the many table as this is deleted when the 'one' table is deleted
Remember to do cascade delete

#Need to have a screening_id on the ticket (rather than the film_id)? This gives the film_id but also more information. - otherwise the screening info is lost once the buy_ticket method is run on a customer.
