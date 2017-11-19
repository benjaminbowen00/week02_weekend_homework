DROP TABLE screenings;
DROP TABLE tickets;
DROP TABLE customers;
DROP TABLE films;

CREATE TABLE films (
id SERIAL4 PRIMARY KEY,
title VARCHAR(255),
price FLOAT(2)
);

CREATE TABLE customers (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255),
  funds FLOAT(2)
);

CREATE TABLE tickets (
id SERIAL4 PRIMARY KEY,
film_id INT4 REFERENCES films(id),
customer_id INT4 REFERENCES customers(id)
);

CREATE TABLE screenings(
id serial4 PRIMARY KEY,
film_id INT4 REFERENCES films(id) ON DELETE CASCADE,
start_time TIMESTAMP,
empty_seats INT2
);
