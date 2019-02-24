<h1><b>Проектная работа по модулю “SQL и получение данных”</b></h1><br/>
<p><b>Что необходимо сделать?<br/>
1) Подготовить базу данных PostgreSQL для работы одним из вариантов:<br/>
* Развернуть с помощью виртуальной машины/vagrant/docker или другим удобным способом<br/>
* Использовать сервис https://www.db-fiddle.com для работы через браузер <br/>
2) Создать не менее 4 таблиц и заполнить их данными. Таблицы должны быть связаны между собой посредством ключей (ID) и представлять какую-то логическую структуру. Тематика данных может быть использована любая.<br/>
3) Написать не менее 10 SQL запросов к базе данных. В запросах должны быть отражены как базовые команды, так и аналитические функции (не менее 3 запросов). Должно присутствовать описание того, что вы получаете путем каждого запроса.<br/>
</b></p><br>
<br/><br/><br/>


<p>1. Подготовка БД.<br/>
Структура БД:<br/>
<img src="bd.PNG" alt=""><br/>
БД разворачивалась на виртуальной машине.<br/>
</p>


<p>2. Создание таблиц и их заполнение.<br/>
SQL-команды на создание таблиц:<br/>
<pre>
CREATE TABLE IF NOT EXISTS Department 
 	(
      id integer PRIMARY KEY,
      name varchar(100)
    );
    
CREATE TABLE IF NOT EXISTS Degree
 	(
      id integer PRIMARY KEY,
      name varchar(50)
    );

CREATE TABLE IF NOT EXISTS Employee 
 	(
      id integer PRIMARY KEY,
      dep_id integer REFERENCES Department(id),
      chief_id integer,
      name varchar(50),
      degree_id integer REFERENCES Degree(id)
    );
   
CREATE TABLE IF NOT EXISTS Publication 
 	(
      id integer PRIMARY KEY,
      name varchar(250),
      magazine varchar(100),
      year integer,
	  rating real
    );

CREATE TABLE IF NOT EXISTS Patient 
 	(
      id integer PRIMARY KEY,
      name varchar(30),
	  surname varchar(30),
      birthday date
    );
    
CREATE TABLE IF NOT EXISTS Emp_Pub 
 	(
      id_emp integer REFERENCES Employee(id),
      id_pub integer REFERENCES Publication(id),
      PRIMARY KEY (id_emp, id_pub)                
    );

CREATE TABLE IF NOT EXISTS Therapy 
 	(
      id_pat integer REFERENCES Patient(id),
      id_emp integer REFERENCES Employee(id),
      date date,
      diagnosis_code varchar(10),
      PRIMARY KEY (id_pat, id_emp, date)                 
    );
</pre>

<br/><br/><br/>



<img src="bd.PNG" alt=""><br/>
БД разворачивалась на виртуальной машине.<br/>
</p>




1) подключиться к Mongo из командной строки Linux и загрузить в Mongo текстовый JSON-файл;
</p>
<pre>
/usr/bin/mongo localhost:27017
</pre>
<pre>
/usr/bin/mongoimport --host localhost --port 27017 --db movies --collection tags --file /usr/local/share/netology/raw_data/simple_tags.json
use movies
</pre>
<img src="hw5_1.PNG" alt="">
<br/><br/>

<p>
2) выполнить запросы к Mongo через консоль:<br/>
2.1) подсчитайте число элементов в созданной коллекции tags в bd movies
</p>
<pre>
db.tags.count()
</pre>
<img src="hw5_2.PNG" alt="">
<br/><br/>

<p>
2.2) подсчитайте число фильмов с конкретным тегом - woman
</p>
<pre>
db.tags.find({name:'woman'}).count()
</pre>
<img src="hw5_3.PNG" alt="">
<br/><br/>

<p>
2.3) используя группировку данных ($groupby) вывести top-3 самых распространённых тегов. <br/>
Удалось справиться только с подсказками в Slack, трудности были в разборке синтаксиса запроса. 
</p>
<pre>
db.tags.aggregate([ {$group: {_id: "$name", tag_count: {$sum: 1}}} , {$sort: {tag_count: -1} } , {$limit : 3} ])
</pre>
<img src="hw5_4.PNG" alt="">
<br/><br/>




