--=============== МОДУЛЬ 4. УГЛУБЛЕНИЕ В SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--База данных: если подключение к облачной базе, то создаёте новую схему с префиксом в 
--виде фамилии, название должно быть на латинице в нижнем регистре и таблицы создаете 
--в этой новой схеме, если подключение к локальному серверу, то создаёте новую схему и 
--в ней создаёте таблицы.

CREATE SCHEMA IF NOT EXISTS serenko;

--Спроектируйте базу данных, содержащую три справочника:
--· язык (английский, французский и т. п.);
--· народность (славяне, англосаксы и т. п.);
--· страны (Россия, Германия и т. п.).
--Две таблицы со связями: язык-народность и народность-страна, отношения многие ко многим. Пример таблицы со связями — film_actor.
--Требования к таблицам-справочникам:
--· наличие ограничений первичных ключей.
--· идентификатору сущности должен присваиваться автоинкрементом;
--· наименования сущностей не должны содержать null-значения, не должны допускаться 
--дубликаты в названиях сущностей.
--Требования к таблицам со связями:
--· наличие ограничений первичных и внешних ключей.

--В качестве ответа на задание пришлите запросы создания таблиц и запросы по 
--добавлению в каждую таблицу по 5 строк с данными.
 
--СОЗДАНИЕ ТАБЛИЦЫ ЯЗЫКИ

CREATE TABLE serenko.languages 
(
    language_id SERIAL PRIMARY KEY,
    name_language VARCHAR(255) UNIQUE NOT NULL
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ ЯЗЫКИ

INSERT INTO serenko.languages(name_language)
VALUES ('английский'),
       ('французский'),
       ('немецкий'),
       ('итальянский'),
       ('русский');

select *
from serenko."languages" l;

--СОЗДАНИЕ ТАБЛИЦЫ НАРОДНОСТИ

CREATE TABLE serenko.nationalities 
(
     nationality_id SERIAL PRIMARY KEY,
     name_nationality VARCHAR(255) UNIQUE NOT null
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ НАРОДНОСТИ

INSERT INTO serenko.nationalities(name_nationality)
VALUES ('британцы'),
       ('французы'),
       ('немцы'),
       ('итальянцы'),
       ('русские');

select *
from serenko.nationalities n;

--СОЗДАНИЕ ТАБЛИЦЫ СТРАНЫ

CREATE TABLE serenko.countries 
(
     country_id SERIAL PRIMARY KEY,
     name_country VARCHAR(255) UNIQUE NOT null
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СТРАНЫ

INSERT INTO serenko.countries(name_country)
VALUES ('Великобритания'),
       ('Франция'),
       ('Германия'),
       ('Италия'),
       ('Россия');
      
select *
from serenko.countries c;

--СОЗДАНИЕ ПЕРВОЙ ТАБЛИЦЫ СО СВЯЗЯМИ

CREATE TABLE serenko.language_nationalities 
(
    language_id INTEGER NOT NULL,
    nationality_id INTEGER NOT NULL,
    PRIMARY KEY (language_id, nationality_id),
    FOREIGN KEY (language_id) REFERENCES serenko.languages(language_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (nationality_id) REFERENCES serenko.nationalities(nationality_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ

INSERT INTO serenko.language_nationalities(language_id, nationality_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5);
      
select *
from serenko.language_nationalities ln2;

--СОЗДАНИЕ ВТОРОЙ ТАБЛИЦЫ СО СВЯЗЯМИ

CREATE TABLE serenko.nationality_countries
(
    country_id INTEGER REFERENCES serenko.countries(country_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    nationality_id INTEGER REFERENCES serenko.nationalities(nationality_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (country_id, nationality_id)
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ

INSERT INTO serenko.nationality_countries(country_id, nationality_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5);

select *
from serenko.nationality_countries nc;

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============


--ЗАДАНИЕ №1 
--Создайте новую таблицу film_new со следующими полями:
--·   	film_name - название фильма - тип данных varchar(255) и ограничение not null
--·   	film_year - год выпуска фильма - тип данных integer, условие, что значение должно быть больше 0
--·   	film_rental_rate - стоимость аренды фильма - тип данных numeric(4,2), значение по умолчанию 0.99
--·   	film_duration - длительность фильма в минутах - тип данных integer, ограничение not null и условие, что значение должно быть больше 0
--Если работаете в облачной базе, то перед названием таблицы задайте наименование вашей схемы.

CREATE TABLE serenko.film_new 
(    film_name varchar(255) not null,
     film_year integer check (film_year > 0),
     film_rental_rate numeric (4, 2) default 0.99,
     film_duration integer not null check (film_duration > 0)
);

--ЗАДАНИЕ №2 
--Заполните таблицу film_new данными с помощью SQL-запроса, где колонкам соответствуют массивы данных:
--·       film_name - array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--·       film_year - array[1994, 1999, 1985, 1994, 1993]
--·       film_rental_rate - array[2.99, 0.99, 1.99, 2.99, 3.99]
--·   	  film_duration - array[142, 189, 116, 142, 195]

/*Первый вариант вставки данных в таблицу. Подходит, если мало значений*/
insert into serenko.film_new (film_name, film_year, film_rental_rate, film_duration)
values ('The Shawshank Redemption', 1994, 2.99, 142),
       ('The Green Mile', 1999, 0.99, 189),
       ('Back to the Future', 1985, 1.99, 116),
       ('Forrest Gump', 1994, 2.99, 142),
       ('Schindlers List', 1993, 3.99, 195);

/*Второй вариант добавления данных в таблицу, когда есть массивы данных*/      
insert into serenko.film_new (film_name, film_year, film_rental_rate, film_duration)
select * from unnest(array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List'],
                     array[1994, 1999, 1985, 1994, 1993], 
                     array[2.99, 0.99, 1.99, 2.99, 3.99], 
                     array[142, 189, 116, 142, 195]); 
     
select *
from serenko.film_new fn;

insert into serenko.film_new (film_name, film_year, film_rental_rate, film_duration)
values (unnest(array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']),
        unnest(array[1994, 1999, 1985, 1994, 1993]), 
        unnest(array[2.99, 0.99, 1.99, 2.99, 3.99]), 
        unnest(array[142, 189, 116, 142, 195])
		); 

--ЗАДАНИЕ №3
--Обновите стоимость аренды фильмов в таблице film_new с учетом информации, 
--что стоимость аренды всех фильмов поднялась на 1.41

update serenko.film_new
set film_rental_rate = film_rental_rate + 1.41;

select *
from serenko.film_new fn;


--ЗАДАНИЕ №4
--Фильм с названием "Back to the Future" был снят с аренды, 
--удалите строку с этим фильмом из таблицы film_new

delete from serenko.film_new
where film_name = 'Back to the Future';

select *
from serenko.film_new fn;

--ЗАДАНИЕ №5
--Добавьте в таблицу film_new запись о любом другом новом фильме

insert into serenko.film_new (film_name, film_year, film_rental_rate, film_duration)
values ('Fantasia park', 2006, 2.99, 131);

select *
from serenko.film_new fn;

--ЗАДАНИЕ №6
--Напишите SQL-запрос, который выведет все колонки из таблицы film_new, 
--а также новую вычисляемую колонку "длительность фильма в часах", округлённую до десятых


select
    *,
    round(film_duration/60.0, 1)  "длительность фильма в часах"
from serenko.film_new;

--ЗАДАНИЕ №7 
--Удалите таблицу film_new

drop table if exists serenko.film_new;
