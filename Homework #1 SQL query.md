
<img src="Homework1_SQL.png" height=400px alt="">

<code>
CREATE DATABASE homework1;
GRANT ALL PRIVILEGES ON DATABASE homework1 TO postgres;
</code>

CREATE TABLE films (
    id_film     serial PRIMARY KEY,       -- первичный ключ, serial - генерирует id
    film_name   VARCHAR (100) NOT NULL,   -- строка до 100 символов, не уникальный, не пустой
    country     VARCHAR (50) NOT NULL,    -- строка до 50 символов, не уник, не пустой
    box_office  VARCHAR (25) NOT NULL     -- строка из 25 символов, не уник, не пустой
);
