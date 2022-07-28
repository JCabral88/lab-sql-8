use sakila;

-- 1. Write a query to display for each store its store ID, city, and country.

select store.store_id as 'Store ID', c.city as 'City', con.country as 'Country'
from store
join staff
on (store.manager_staff_id = staff.staff_id)
join address a
on (store.address_id = a.address_id)
join city c
on (c.city_id = a.city_id)
join country con
on (con.country_id = c.country_id);

-- 2. Write a query to display how much business, in dollars, each store brought in.

select store.store_id as 'Store', concat(c.city, ', ', con.country) as 'Store Location', SUM(p.amount) as 'Total Income'
from store
join staff
on (store.manager_staff_id = staff.staff_id)
join payment p
on (staff.staff_id = p.staff_id)
join address a
on (store.address_id = a.address_id)
join city c
on (c.city_id = a.city_id)
join country con
on (con.country_id = c.country_id)
group by store.store_id;

-- Australia has bigger income

-- 3. Which film categories are longest?

select avg(f.length) as avg_duration, ca.name
from film as f
join film_category as fc
on f.film_id = fc.film_id
join category as ca
on fc.category_id = ca.category_id
group by ca.name
order by avg_duration desc;
-- Sports cat. have the longest duration.

-- 4. Display the most frequently rented movies in descending order.

select sum(r.inventory_id) as rented_movies,
f.title from rental as r
inner join inventory as i
on r.inventory_id = i.inventory_id
inner join film as f
on i.film_id = f.film_id
group by f.title
order by rented_movies desc;
-- Zorro Ark is the most rented movie

-- 5. List the top five genres in gross revenue in descending order.
select sum(p.amount) as revenue, ca.name, fc.category_id 
from payment as p
inner join rental as r
on p.rental_id = r.rental_id
inner join inventory as i
on r.inventory_id = i.inventory_id
inner join film as f
on i.film_id = f.film_id
inner join film_category as fc
on f.film_id = fc.film_id
inner join category as ca
on fc.category_id = ca.category_id
group by ca.name, fc.category_id 
order by revenue desc
limit 5;
-- Sports, Sci-Fi, Animation, Drama, Comedy

-- 6. Is "Academy Dinosaur" available for rent from Store 1?

select f.title, r.rental_id, r.inventory_id, r.rental_date, r.return_date, s.store_id
from film  as f
inner join inventory as i
on f.film_id = i.film_id
inner join rental as r
on i.inventory_id = r.inventory_id
inner join store as s
on i.store_id = s.store_id
where f.title = "Academy Dinosaur" and s.store_id = 1;
-- YES

-- 7. Get all pairs of actors that worked together.

select a1.film_id, concat(a1.first_name, ' ', a1.last_name) as actor1, concat(a2.first_name, ' ', a2.last_name) as actor2
from (select a.actor_id, a.first_name, a.last_name, fa.film_id
from actor a
join film_actor fa on a.actor_id = fa.actor_id) a1
join(select a.actor_id, a.first_name, a.last_name, fa.film_id
from actor a
join film_actor fa on a.actor_id = fa.actor_id) a2
on a1.film_id = a2.film_id and a1.actor_id <> a2.actor_id;

-- 8. Get all pairs of customers that have rented the same film more than 3 times.

select c1.customer_id as customer_id1, 
concat(c1.first_name, ' ', c1.last_name) as customer_name1, c2.customer_id as customer_id2,
concat(c2.first_name, ' ', c2.last_name) as customer_name2, count(c1.rental_id) as number_of_rentals, c1.film_id
from (select c.customer_id, c.first_name, c.last_name, r.rental_id, f.film_id
from customer c
join rental r on c.customer_id = r.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id) c1
join (SELECT c.customer_id, c.first_name, c.last_name, r.rental_id, f.film_id
from customer c
join rental r on c.customer_id = r.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id) c2 on c1.film_id = c2.film_id
and c1.customer_id <> c2.customer_id
group by 1 , 3
having count(c1.film_id) > 3 and count(c2.film_id) > 3
order by 5 desc;

-- 9. For each film, list actor that has acted in more films.

select f.title as film_title,
concat(a.first_name, ' ', a.last_name) as actor_name,
count(f.film_id) number_of_films
from actor a
join film_actor fa on a.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id
group by f.film_id
order by 3 DESC;