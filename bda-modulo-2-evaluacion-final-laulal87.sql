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


				-- He hecho la comprobación que por si estaban todos los actores en la tabla film_actor porque no encontró ningún actor
				SELECT actor_id
				FROM film_actor
				WHERE actor_id > 0 AND  actor_id <= 300
				GROUP BY actor_id;

-- 16.  Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010

SELECT title, release_year
	FROM film
	WHERE release_year >= 2005 AND release_year <= 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT film.title
FROM film
	INNER JOIN film_category
	ON  film.film_id = film_category.film_id
		INNER JOIN category
		ON film_category.category_id = category.category_id 
WHERE category.name = 'Family';

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT actor.first_name, actor.last_name, COUNT(film.film_id)
FROM actor
	INNER JOIN film_actor
	ON actor.actor_id = film_actor.actor_id  
		INNER JOIN film
		ON film_actor.film_id = film.film_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name
HAVING COUNT(film.film_id) >= 10;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title
	FROM film
    WHERE rating = 'R' AND length > 120;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
	
SELECT c.name, AVG(f.length) AS Promedio_duracion
	FROM category AS c
		INNER JOIN film_category AS fc
		ON c.category_id = fc.category_id
			INNER JOIN film as f
			ON fc.film_id = f.film_id
GROUP BY c.category_id
HAVING AVG(f.length) < 120;


-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT a.first_name, a.last_name, COUNT(f.film_id) AS Películas_actuadas
FROM actor AS a
	INNER JOIN film_actor AS fa
	ON a.actor_id = fa.actor_id  
		INNER JOIN film as f
		ON fa.film_id = f.film_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(f.film_id) >= 5;


/* 22.  Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para
 encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. */
 


SELECT DISTINCT title
FROM film AS f
INNER JOIN inventory AS i 
    ON f.film_id = i.film_id
INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
WHERE r.rental_id IN (                           -- SUBCONSULTA para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
    SELECT rental_id
    FROM rental
    WHERE DATEDIFF(return_date, rental_date) > 5);  -- DATEDIFF funcion para encontrar la diferencia entre fechas

/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
 Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego
 exclúyelos de la lista de actores. */
 
SELECT a.first_name, a.last_name
	FROM actor AS a
		WHERE a.actor_id NOT IN (SELECT a.actor_id
		FROM actor AS a
			INNER JOIN film_actor as fa
			ON a.actor_id = fa.actor_id
				INNER JOIN film AS f
				ON fa.film_id = f.film_id
					INNER JOIN film_category AS fc
					ON f.film_id = fc.film_id
						INNER JOIN category AS c
						ON fc.category_id = c.category_id
		WHERE c.name ='Horror');


-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.













