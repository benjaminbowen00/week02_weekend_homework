#Better to think of the save function as a create - e.g. if you change an attribute and then save it, this will create a new row in the table - you need to update

WHen we do this:   
Customer method:
def buy_ticket(film)
    hash = {'customer_id'=> @id, 'film_id'=> film.id}
    ticket = Ticket.new(hash)
    ticket.save
    @funds -= film.price
  end
We create the ticket object but it doesn't have a name - how can we do anything on this e.g. update in the console? - Same problem as before about a different object being created if we use the info from the database
