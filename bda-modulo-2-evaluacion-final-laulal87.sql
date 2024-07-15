-- Usar BBDD Sakila
USE Sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title     -- DISTICNCT para que no aparezcan duplicados
	FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

Select title
	FROM film
	WHERE rating = 'PG-13';   -- se usa para filtrar filas 
    

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
    WHERE actor_id BETWEEN 10 AND 20;	-- BETWEEN para números entre 10 y 20
    
-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

Select title, rating
	FROM film
	WHERE rating NOT IN ('R', 'PG-13');    -- NOT IN para escoger los que no incluyan
    
-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT COUNT(film_id) AS cantidad_peliculas, rating
	FROM film
    GROUP BY rating;                            -- GROUP BY para agrupar por categorías
    
-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS Total_Alquiladas
	FROM customer AS c
	INNER JOIN rental AS r                                -- INNER JOIN para juntar filas dos tablas en este caso customer y rental. Nos devolverá las filas dónde haya coincidencia en ambas tablas 
	ON c.customer_id = r.customer_id
	GROUP BY c.customer_id, c.first_name, c.last_name;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT COUNT(r.rental_id) AS Total_Alquiladas, c.name AS Nombre_Categoria
	FROM rental As r
		INNER JOIN inventory AS i                           -- INNER JOIN para juntar filas dos tablas. Nos devolverá las filas dónde haya coincidencia en ambas tablas 
		ON r.inventory_id = i.inventory_id
			INNER JOIN film As f
			ON i.film_id = f.film_id
				INNER JOIN film_category AS fc 
				ON f.film_id = fc.film_id
					INNER JOIN category AS c
					ON fc.category_id = c.category_id
	GROUP BY c.name;                                     	-- Agrupamos por el nombre de la categoria

-- 12.  Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración
 
 SELECT AVG(length), rating    -- AVG para calcular el promedio
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
	FROM actor AS a
		LEFT JOIN film_actor as fa         -- se utiliza cuando quieres asegurarte de incluir todas las filas de la tabla izquierda sin importar las de la izquierda en este caso queríamos asegurar todos los actores
		ON a.actor_id = fa.actor_id
	WHERE a.actor_id IS NULL                                
	GROUP BY a.actor_id ;


				-- He hecho la comprobación que por si estaban todos los actores en la tabla film_actor porque no encontró ningún actor
				SELECT actor_id
				FROM film_actor
				WHERE actor_id > 0 AND  actor_id <= 300
				GROUP BY actor_id;

-- 16.  Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010

SELECT title, release_year
	FROM film
	WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT f.title
FROM film AS f
	INNER JOIN film_category AS fc
	ON  f.film_id = fc.film_id
		INNER JOIN category AS c
		ON fc.category_id = c.category_id 
WHERE c.name = 'Family';

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT a.first_name, a.last_name, COUNT(f.film_id) AS Pelis_aparece
FROM actor AS a
	INNER JOIN film_actor AS fa
	ON a.actor_id = fa.actor_id  
		INNER JOIN film As f
		ON fa.film_id = f.film_id
GROUP BY a.actor_id
HAVING COUNT(f.film_id) >= 10;                            -- COUNT cuenta los film id   HAVING se aplica a grupos de filas generados por GROUP BY.

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
GROUP BY a.actor_id
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

SELECT title
	FROM film AS f
		INNER JOIN film_category AS fc
		ON f.film_id = fc.film_id
			INNER JOIN category AS c
			ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length >180 ; 

/* 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el
 nombre y apellido de los actores y el número de películas en las que han actuado juntos.
*/
  
-- Creamos una CTE (Common Table Expression) para obtener los nombres y apellidos de los actores
WITH nombre_actores AS (
    SELECT 
        actor_id,      -- ID único de cada actor
        first_name,    -- Nombre del actor
        last_name      -- Apellido del actor
    FROM actor         -- Tabla de actores
)

-- Seleccionamos los nombres y apellidos de los actores que han actuado juntos en películas
SELECT 
    a1.first_name AS actor1_nombre,       -- Nombre del primer actor
    a1.last_name AS actor1_apellido,      -- Apellido del primer actor
    a2.first_name AS actor2_nombre,       -- Nombre del segundo actor
    a2.last_name AS actor2_apellido,      -- Apellido del segundo actor
    COUNT(fa1.film_id) AS numero_peliculas -- Número de películas en las que ambos actores han actuado juntos
    
FROM 
    film_actor AS fa1                    -- Tabla de relación entre películas y actores (primer actor)
    INNER JOIN film_actor AS fa2         -- Segunda instancia de la misma tabla para el segundo actor
        ON fa1.film_id = fa2.film_id     -- Nos aseguramos de que ambos actores han actuado en la misma película
        AND fa1.actor_id < fa2.actor_id  -- Evitamos duplicar pares y ordenamos los actores por su ID

			INNER JOIN nombre_actores AS a1      -- Unimos la CTE para obtener el nombre y apellido del primer actor
				ON fa1.actor_id = a1.actor_id

			INNER JOIN nombre_actores AS a2      -- Unimos la CTE para obtener el nombre y apellido del segundo actor
				ON fa2.actor_id = a2.actor_id

-- Agrupamos por los nombres y apellidos de ambos actores para contar las películas en las que han actuado juntos
GROUP BY
    a1.first_name, 
    a1.last_name,
    a2.first_name, 
    a2.last_name
    ;

