Проект базы данных:<br>
<img src="Homework1_SQL.png" height=400px alt="">
<br><br>
SQL-запрос для создания базы данных под это задание:<br>
<code>
CREATE DATABASE homework1;<br>
GRANT ALL PRIVILEGES ON DATABASE homework1 TO postgres;<br>
</code>
<br><br>
SQL-запрос для создания таблицы <b>films</b><br>
<code>
CREATE TABLE films (<br>
    id_film     serial PRIMARY KEY,       -- первичный ключ, serial - генерирует id<br>
    film_name   VARCHAR (100) NOT NULL,   -- строка до 100 символов, не уникальный, не пустой<br>
    country     VARCHAR (50) NOT NULL,    -- строка до 50 символов, не уник, не пустой<br>
    box_office  VARCHAR (25) NOT NULL     -- строка из 25 символов, не уник, не пустой<br>
);<br>
</code>
<br><br>
