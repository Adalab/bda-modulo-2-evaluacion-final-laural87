-- Usar BBDD Sakila
USE Sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title
	FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

Select title
	FROM film
	WHERE rating = 'PG-13';

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title , description
	FROM film
	WHERE description LIKE '%amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title, length
	FROM film
	WHERE length > 120;

-- 5. Recupera los nombres de todos los actores.

SELECT first_name, last_name
	FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name, last_name
	FROM actor
	WHERE last_name = 'Gibson';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name, last_name
	FROM actor
    WHERE actor_id >=10 AND actor_id <= 20;	
    
-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

Select title, rating
	FROM film
	WHERE rating NOT IN ('R', 'PG-13');
    
-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT COUNT(film_id) AS cantidad_peliculas, rating
	FROM film
    GROUP BY rating;
    
-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS Total_Alquiladas
	FROM customer
	INNER JOIN rental
	ON customer.customer_id = rental.customer_id
	GROUP BY customer.customer_id, customer.first_name, customer.last_name;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT COUNT(rental.rental_id) AS Total_Alquiladas, category.name AS Nombre_Categoria
FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name;

-- 12.  Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración
 
 SELECT AVG(length), rating
 FROM film
 GROUP BY rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT first_name, last_name
FROM Actor
INNER JOIN film_actor ON Actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = 'Indian Love';

-- 14.  Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title 
	FROM film
	WHERE title LIKE '%dog%' or title LIKE '%cat%' ;

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.

SELECT first_name, last_name
FROM actor
LEFT JOIN film_actor
ON actor.actor_id = film_actor.actor_id
WHERE actor.actor_id IS NULL
GROUP BY actor.first_name, actor.last_name ;


				-- He hecho la comprobación que por si estaban todos los actores en la tabla film_actor
				SELECT actor_id
				from film_actor
				WHERE actor_id > 0 AND  actor_id <= 300
				GROUP BY actor_id;


-- 16.  Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010

Select title, release_year
FROM film
WHERE release_year >= 2005 AND release_year <= 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".







