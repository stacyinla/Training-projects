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
      PRIMARY KEY (id_emp, id_pub)                 -- составной первичный ключ
    );

CREATE TABLE IF NOT EXISTS Therapy 
 	(
      id_pat integer REFERENCES Patient(id),
      id_emp integer REFERENCES Employee(id),
      date date,
      diagnosis_code varchar(10) REFERENCES Diagnosis(code),
      PRIMARY KEY (id_pat, id_emp, date)                 -- составной первичный ключ
    );

psql -U postgres -c "\\copy Department FROM '/usr/local/share/netology/itog/Department.csv' DELIMITER ',' CSV HEADER"
psql -U postgres -c "\\copy Degree FROM '/usr/local/share/netology/itog/Degree.csv' DELIMITER ',' CSV HEADER"
psql -U postgres -c "\\copy Emp_Pub FROM '/usr/local/share/netology/itog/Emp_Pub.csv' DELIMITER ',' CSV HEADER"
psql -U postgres -c "\\copy Employee FROM '/usr/local/share/netology/itog/Employee.csv' DELIMITER ',' CSV HEADER"
psql -U postgres -c "\\copy Patient FROM '/usr/local/share/netology/itog/Patient.csv' DELIMITER ',' CSV HEADER"
psql -U postgres -c "\\copy Publication FROM '/usr/local/share/netology/itog/Publication.csv' DELIMITER ',' CSV HEADER"
psql -U postgres -c "\\copy Therapy FROM '/usr/local/share/netology/itog/Therapy.csv' DELIMITER ',' CSV HEADER"




--a Вывести список названий департаментов и количество главных врачей в каждом из этих департаментов

WITH Count_table AS
	(
      SELECT department_id, 
      		 count(distinct chief_doc_id) AS chief_doc_count
      FROM Employee
      GROUP BY department_id
    )
SELECT 	Department.id AS id,
		Department.name AS name,
        Count_table.chief_doc_count
FROM Department JOIN Count_table
	ON Department.id = Count_table.department_id;
    

--b Вывести список департаментов, в которых работают 3 и более сотрудников (id и название департамента, количество сотрудников)

WITH Count_table AS
	(
      SELECT Employee.department_id AS department_id,
      		 COUNT(Employee.id) OVER (PARTITION BY department_id) AS Employee_count
      FROM Employee
      )
SELECT 	DISTINCT Department.id AS id,
		Department.name AS name,
        Count_table.Employee_Count
FROM Department JOIN Count_table
	ON Department.id = Count_table.department_id
WHERE Count_table.Employee_count > 2
;

--c Вывести список департаментов с максимальным количеством публикаций  (id и название департамента, количество публикаций)


WITH Sum_table AS
	(
      SELECT  	DISTINCT department_id,
				SUM(num_public) OVER (PARTITION BY department_id ) AS sum_public_value
      FROM Employee
      ORDER BY sum_public_value DESC
    )
SELECT	Sum_table.department_id,
		Department.name,
        Sum_table.sum_public_value
FROM Sum_table JOIN Department
	ON Sum_table.department_id = Department.id
WHERE Sum_table.sum_public_value IN (SELECT  	SUM(num_public) OVER (PARTITION BY department_id ) AS sum_public_value
      								FROM Employee
     								ORDER BY sum_public_value DESC 
                           			limit 1)
;
      
      
--d Вывести список сотрудников с минимальным количеством публикаций в своем департаменте (id и название департамента, имя сотрудника, количество публикаций)

WITH Min_table AS
	 (
     SELECT DISTINCT department_id,
       		Department.name AS dep_name,
     		MIN(num_public) OVER (PARTITION BY department_id) AS min_public
     FROM Department INNER JOIN Employee
     		ON Employee.department_id = Department.id
     )
SELECT  DISTINCT Min_table.department_id, 
		dep_name, 
        name, 
        num_public
FROM Min_table LEFT JOIN Employee
	ON Employee.department_id = Min_table.department_id AND Employee.num_public = Min_table.min_public
ORDER BY Min_table.department_id;



--e Вывести список департаментов и среднее количество публикаций для тех департаментов, в которых работает более одного главного врача (id и название департамента, среднее количество публикаций)


WITH Glav AS
	(
      SELECT 	DISTINCT chief_doc_id
      FROM Employee
	)
SELECT  department_id,
		Department.name,
		AVG(num_public)
FROM Employee INNER JOIN Glav 
	ON id = Glav.chief_doc_id
    	INNER JOIN Department
    		ON Employee.department_id = Department.id
GROUP BY department_id, Department.name
HAVING COUNT(Employee.id) > 1
ORDER BY department_id
;
   
   