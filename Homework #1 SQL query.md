Проект базы данных:<br>
<img src="Homework1_SQL.png" height=400px alt="">
<br><br>
SQL-запрос для создания базы данных под это задание:<br>
<pre>
CREATE DATABASE homework1;
GRANT ALL PRIVILEGES ON DATABASE homework1 TO postgres;
</pre>
<br><br>
SQL-запрос для создания таблицы <b>films</b><br>
<pre>
CREATE TABLE films (
    id_film     serial PRIMARY KEY,       -- первичный ключ, serial - числовой тип данных с автоувеличением
    film_name   VARCHAR (100) NOT NULL,   -- строка до 100 символов, не уникальный, не пустой
    country     VARCHAR (50) NOT NULL,    -- строка до 50 символов, не уник, не пустой
    box_office  VARCHAR (25)              -- строка из 25 символов
);
</pre>
<br><br>
SQL-запрос для создания таблицы <b>persons</b><br>
<pre>
CREATE TABLE persons (
    id_person   serial PRIMARY KEY,       -- первичный ключ, serial - генерирует id
    person_name VARCHAR (20)[2] NOT NULL  -- массив из 2-ух строк до 20 символов, не пустой
);
</pre>
<br><br>
SQL-запрос для создания таблицы <b>persons_films</b><br>
<pre>
CREATE TABLE persons_films (
    id_person   REFERENCES persons(id_person),       -- PK and FK (persons)
    id_film     REFERENCES films(id_film),           -- PK and FK (films)
    role        VARCHAR(25),                         -- строка до 25 символов
    PRIMARY KEY (id_person, id_film)                 -- составной первичный ключ
);
</pre>
<br><br>
