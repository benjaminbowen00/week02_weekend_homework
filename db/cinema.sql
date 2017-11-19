DROP TABLE tickets;
DROP TABLE screenings;
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

CREATE TABLE screenings(
id serial4 PRIMARY KEY,
film_id INT4 REFERENCES films(id) ON DELETE CASCADE,
start_time TIMESTAMP,
empty_seats INT2
);

CREATE TABLE tickets (
  id SERIAL4 PRIMARY KEY,
  screening_id INT4 REFERENCES screenings(id),
  customer_id INT4 REFERENCES customers(id)
);
