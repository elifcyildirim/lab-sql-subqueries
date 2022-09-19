--  SQL Subqueries 3.03

USE sakila;

-- q1 How many copies of the film Hunchback Impossible exist in the inventory system? 
select * from film
where title= 'Hunchback Impossible'; -- film_id=439

select count(*) from(
select f.film_id, i.inventory_id from film f
join inventory i
using (film_id)
where f.title='Hunchback Impossible') sub1;

-- q2 List all films whose length is longer than the average of all the films.

SELECT * FROM sakila.film
WHERE length > (
  SELECT AVG(length)
  FROM film
);

-- q3 Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name
FROM actor
WHERE actor_id in
	(SELECT actor_id FROM film_actor
	WHERE film_id in 
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));

-- OR

SELECT f.title, a.first_name, a.last_name, f.film_id, fa.actor_id FROM film_actor fa
JOIN actor a
USING (actor_id)
JOIN film f
USING (film_id)
WHERE f.title ='Alone Trip';

-- q4 Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.

SELECT * FROM film
WHERE film_id in
	(SELECT film_id FROM film_category
	WHERE category_id in 
		(SELECT category_id FROM category
		WHERE name = "family"));

-- q5 Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.

-- SELECT * FROM customer;
-- SELECT * FROM address;
-- SELECT * FROM city;
-- SELECT * FROM country;

SELECT first_name, last_name, email FROM customer
WHERE address_id in
	(SELECT address_id FROM address
    WHERE city_id IN
    (SELECT city_id FROM city
    WHERE country_id IN
    (SELECT country_id FROM country
    WHERE country='CANADA')));

-- q6 Which are films starred by the most prolific actor?
-- Most prolific actor is defined as the actor that has acted in the most number of films.
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.


SELECT actor_id, COUNT(film_id) FROM film_actor
GROUP by actor_id
ORDER by COUNT(film_id) DESC
LIMIT 1; -- actor_id 107 is the most prolific actor

SELECT * FROM film
WHERE film_id IN (
SELECT film_id FROM film_actor
WHERE actor_id= '107');

-- q7 Films rented by most profitable customer. You can use the customer table and payment table to find the 
-- most profitable customer ie the customer that has made the largest sum of payments

-- SELECT * FROM film;
-- SELECT * FROM payment;
-- SELECT * FROM rental;
-- SELECT * FROM customer;

SELECT customer_id, SUM(amount) FROM payment
GROUP by customer_id
ORDER by SUM(amount) DESC
LIMIT 1; -- customer_id =526 is the most profitable

SELECT * FROM film
WHERE film_id IN (
SELECT film_id FROM inventory
WHERE inventory_id IN (
SELECT inventory_id FROM rental
WHERE customer_id='526'));

-- q8 Customers who spent more than the average payments.

SELECT * FROM customer
WHERE customer_id IN (
SELECT customer_id FROM payment
WHERE amount> (SELECT 
AVG(amount) FROM payment));

-- the query below is to see the sum(amount) per the customer who paid more than the avg (amount)
SELECT customer_id, SUM(amount) FROM payment 
WHERE amount> (SELECT 
AVG(amount) FROM payment)
GROUP BY customer_id;