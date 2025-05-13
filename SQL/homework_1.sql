--=============== МОДУЛЬ 2. РАБОТА С БАЗАМИ ДАННЫХ =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите уникальные названия городов из таблицы городов.

select distinct city
from city;

--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания, чтобы запрос выводил только те города,
--названия которых начинаются на “L” и заканчиваются на “a”, и названия не содержат пробелов.

select distinct city
from city
where city like 'L%a' and city not like '% %'
order by city;

--ЗАДАНИЕ №3
--Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись 
--в промежуток с 17 июня 2005 года по 19 июня 2005 года включительно, 
--и стоимость которых превышает 1.00.
--Платежи нужно отсортировать по дате платежа.


select p.payment_id, p.payment_date, p.amount
from payment p 
where (p.payment_date::date between '2005.06.17' and '2005.06.19') and
       p.amount > 1.00
order by p.payment_date;

--ЗАДАНИЕ №4
-- Выведите информацию о 10-ти последних платежах за прокат фильмов.

select p.payment_id, p.payment_date, p.amount
from payment p 
order by p.payment_date desc
limit 10;

--ЗАДАНИЕ №5
--Выведите следующую информацию по покупателям:
--  1. Фамилия и имя (в одной колонке через пробел)
--  2. Электронная почта
--  3. Длину значения поля email
--  4. Дату последнего обновления записи о покупателе (без времени)
--Каждой колонке задайте наименование на русском языке.

select c.last_name || ' ' || c.first_name as "Фамилия и имя", 
       c.email as "Электронная почта", CHAR_LENGTH(c.email) as "Длина Email",
       c.last_update::date as "Дата"
from customer c;

--ЗАДАНИЕ №6
--Выведите одним запросом только активных покупателей, имена которых KELLY или WILLIE.
--Все буквы в фамилии и имени из верхнего регистра должны быть переведены в нижний регистр.

select lower(c.last_name) as last_name, lower(c.first_name) as first_name
from customer c 
where c.active = 1 and
      c.first_name in ('KELLY', 'WILLIE');

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите одним запросом информацию о фильмах, у которых рейтинг "R" 
--и стоимость аренды указана от 0.00 до 3.00 включительно, 
--а также фильмы c рейтингом "PG-13" и стоимостью аренды больше или равной 4.00.

select f.film_id, f.title, f.description, f.rating, f.rental_rate
from film f
where (f.rating = 'R' and f.rental_rate between 0.00 and 3.00) or
	  (f.rating = 'PG-13' and f.rental_rate >= 4.00);

--ЗАДАНИЕ №2
--Получите информацию о трёх фильмах с самым длинным описанием фильма.

select f.film_id, f.title, f.description
from film f
order by LENGTH(f.description) desc
limit 3;

--ЗАДАНИЕ №3
-- Выведите Email каждого покупателя, разделив значение Email на 2 отдельных колонки:
--в первой колонке должно быть значение, указанное до @, 
--во второй колонке должно быть значение, указанное после @.

SELECT 
    customer_id,
    email,  
    SUBSTRING(email FOR STRPOS(email, '@')) "Email before @", 
    SUBSTRING(email FROM STRPOS(email, '@') + 1) "Email after @"
FROM customer;

--ЗАДАНИЕ №4
--Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: 
--первая буква должна быть заглавной, остальные строчными.

SELECT 
   customer_id, 
   email,  
   SUBSTRING(email from 1 FOR 1) || lower(SUBSTRING(email from 2 FOR STRPOS(email, '@') - 2)) "Email before @", 
   UPPER(SUBSTRING(email FROM STRPOS(email, '@') + 1 FOR 1))||SUBSTRING(email FROM STRPOS(email, '@') + 2) "Email after @"
FROM customer;


--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ 2==============

--ЗАДАНИЕ №1
--Получите из таблицы film атрибуты: id фильма, название,
--описание, год релиза. Переименуйте поля так, чтобы все они
--начинались со слова Film (FilmTitle вместо title и т. п.)

SELECT film_id AS "Filmfilm_id", title AS "Filmtitle",
description AS "Filmdescriprion", release_year AS "Filmrelease_year"
FROM film;

--ЗАДАНИЕ №2
--В таблице dvdrental есть два атрибута: rental_duration — длина
--периода аренды в днях и rental_rate — стоимость аренды фильма
--на этот промежуток времени. Для каждого фильма из таблицы 
--film получите стоимость его аренды в день

SELECT title, rental_rate/rental_duration AS cost_per_day
FROM film;

--ЗАДАНИЕ №3
--Отсортировать список фильмов по убыванию стоимости за день аренды

SELECT title, rental_rate/rental_duration AS cost_per_day
FROM film
order by cost_per_day desc;

--ЗАДАНИЕ №4
--Вывести все уникальные годы выпуска фильмов

SELECT DISTINCT release_year
FROM film;

--ЗАДАНИЕ №5
--Вывести весь список фильмов имеющий рейтинг 'PG-13'

SELECT title, release_year, rating
FROM film
WHERE rating = 'PG-13';