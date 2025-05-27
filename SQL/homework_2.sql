--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.
select 
    c.last_name ||' '|| c.first_name "Customer_name", 
    a.address, 
    ct.city, 
    cr.country 
from customer c 
join address a using (address_id)
join city ct using (city_id)
join country cr using (country_id);


--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.

select 
    store_id "ID магазина", 
    count(customer_id) "Количество покупателей"
from customer
group by store_id;

--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.

select 
    store_id "ID магазина", 
    count(customer_id) "Количество покупателей"
from customer
group by store_id
having count(customer_id) > 300;

-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.

select 
	c."ID магазина",
	c."Количество покупателей",
    ct.city "Город",
    st.last_name || ' ' || st.first_name "Имя сотрудника"
from
    (select 
    	store_id "ID магазина", 
    	count(customer_id) "Количество покупателей"
	from customer
	group by store_id
	having count(customer_id) > 300) c
join store s on s.store_id = c."ID магазина"   
join address a on s.address_id = a.address_id 
join city ct using (city_id)
join staff st on s.store_id = st.store_id;



select 
    s.store_id "ID магазина", 
    count(distinct c.customer_id) "Количество покупателей",
    ct.city "Город",
    st.last_name || ' ' || st.first_name "Имя сотрудника"
from store s 
join customer c using (store_id)   
join address a on s.address_id = a.address_id 
join city ct using (city_id)
join staff st on s.store_id = st.store_id 
group by s.store_id, ct.city, "Имя сотрудника"
having count(c.customer_id) > 300;

--Лучше выполнить через подзапросы. explain ANALYZE

--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

select 
    c.last_name ||' '|| c.first_name "Фамилия и имя покупателя",
    count(rental_id) "Количество фильмов"
from customer c 
join rental r using (customer_id)
group by c.customer_id
order by "Количество фильмов" desc
limit 5;


--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма


select 
    c.last_name ||' '|| c.first_name "Фамилия и имя покупателя",
    q.counter "Количество фильмов",
    q.summa "Общая стоимость платежей",
    q.minn "Минимальная стоимость платежа",
    q.maxx "Максимальная стоимость платежа"
from customer c 
join (
      select
      	customer_id,
        count(distinct rental_id) counter, 
        round(sum(amount)) summa,
        min(amount) minn,
        max(amount) maxx
        from payment
        group by customer_id) q
on c.customer_id = q.customer_id;

--ЗАДАНИЕ №5
--Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
 --чтобы в результате не было пар с одинаковыми названиями городов. 
 --Для решения необходимо использовать декартово произведение.
 
select 
    c.city "Город 1", 
    s.city "Город 2"
from city c 
cross join city s 
where c.city <> s.city;

--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
--и дате возврата фильма (поле return_date), 
--вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.

select 
	r.customer_id "ID покупателя",
    round(avg(return_date::date - rental_date::date), 2) "Среднее кол-во дней на возврат"
from rental r
group by r.customer_id
order by r.customer_id;
   

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.

select
	f."Название фильма",
	f."Рейтинг",
	c.name "Жанр",
    f.release_year "Год выпуска",
    l.name "Язык",
    f."Количество аренд",
    f."Общая стоимость аренды"
from
	(select  
		f.film_id,
		f.language_id, 
		f.release_year,
    	f.title "Название фильма",
    	f.rating "Рейтинг",
    	count(r.rental_id) "Количество аренд",
    	sum(p.amount) "Общая стоимость аренды"
	from film f 
    left join inventory i using (film_id)
    left join rental r using (inventory_id)
    left join payment p using (rental_id)
    group by f.film_id) f
join language l on l.language_id = f.language_id
join film_category fc on f.film_id = fc.film_id 
join category c using (category_id);


select  
    f.title "Название фильма",
    f.rating "Рейтинг",
    c.name "Жанр",
    f.release_year "Год выпуска",
    l.name "Язык",
    count(r.rental_id) "Количество аренд",
    sum(p.amount) "Общая стоимость аренды"
from film f 
    left join inventory i using (film_id)
    left join rental r using (inventory_id)
    left join payment p using (rental_id)
    join language l using(language_id)
    join film_category fc on f.film_id = fc.film_id 
    join category c using (category_id)
group by f.film_id, l.language_id, c.category_id;



--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания и выведите с помощью запроса фильмы, которые ни разу не брали в аренду.


select
	f."Название фильма",
	f."Рейтинг",
	c.name "Жанр",
    f.release_year "Год выпуска",
    l.name "Язык",
    f."Количество аренд",
    f."Общая стоимость аренды"
from
	(select  
		f.film_id,
		f.language_id, 
		f.release_year,
    	f.title "Название фильма",
    	f.rating "Рейтинг",
    	count(r.rental_id) "Количество аренд",
    	sum(p.amount) "Общая стоимость аренды"
	from film f 
    left join inventory i using (film_id)
    left join rental r using (inventory_id)
    left join payment p using (rental_id)
    where i.film_id is null
    group by f.film_id) f
join language l on l.language_id = f.language_id
join film_category fc on f.film_id = fc.film_id 
join category c using (category_id);

select  
    f.title "Название фильма",
    f.rating "Рейтинг",
    c.name "Жанр",
    f.release_year "Год выпуска",
    l.name "Язык",
    count(r.rental_id) "Количество аренд",
    sum(p.amount) "Общая стоимость аренды"
from film f 
left join inventory i using (film_id)
left join rental r using (inventory_id)
left join payment p using (rental_id)
join language l using(language_id)
join film_category fc on f.film_id = fc.film_id 
join category c using (category_id) 
where i.film_id is null
group by f.film_id, c.category_id, l.language_id;


--ЗАДАНИЕ №3
--Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".

select
    p.staff_id,
    count(p.payment_id) "Количество продаж",
    case 
 	    when count(p.staff_id) > 7300 then 'Да'
 	    else 'Нет'
    end "Премия"
from payment p
group by p.staff_id; 

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ 2==============

--ЗАДАНИЕ №1
--Выведите список названий всех фильмов и их языков (таблица language)

SELECT f.title, l."name"
FROM film f 
join "language" l using (language_id)


--ЗАДАНИЕ №2
--Выведите список всех актёров, снимавшихся в фильме Lambs Cincinatti (film_id = 508).
--Надо использовать JOIN два раза и один раз WHERE

select f.title, a.first_name, a.last_name
from film f 
join film_actor fa using (film_id)
join actor a using (actor_id)
where f.film_id = 508

SELECT f.title, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
LEFT JOIN film f ON f.film_id = fa.film_id
WHERE f.film_id = 508


--ЗАДАНИЕ №3
--Подсчитайте количество актёров в фильме Grosse Wonderful (id – 384)

select count(fa.actor_id)
from film f 
join film_actor fa using (film_id)
where f.film_id = 384


--ЗАДАНИЕ №4
--Выведите список фильмов, в которых снималось больше 10 актёров

select f.title, count(fa.actor_id)
from film f 
join film_actor fa using (film_id)
group by f.film_id 
having count(fa.actor_id) > 5