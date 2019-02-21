/*
CREATE TABLE IF NOT EXISTS Department 
 	(
      id integer PRIMARY KEY,
      name varchar(100)
    );
    
 CREATE TABLE IF NOT EXISTS Employee 
 	(
      id integer PRIMARY KEY,
      department_id integer REFERENCES Department(id),
      chief_doc_id integer,
      name varchar(50),
      num_public integer
    );

INSERT INTO Department values
('1', 'Therapy'),
('2', 'Neurology'),
('3', 'Cardiology'),
('4', 'Gastroenterology'),
('5', 'Hematology'),
('6', 'Oncology');

INSERT INTO Employee values
('1', '1', '1', 'Kate', 4),
('2', '1', '1', 'Lidia', 2),
('3', '1', '1', 'Alexey', 1),
('4', '1', '2', 'Pier', 7),
('5', '1', '2', 'Aurel', 6),
('6', '1', '2', 'Klaudia', 1),
('7', '2', '3', 'Klaus', 12),
('8', '2', '3', 'Maria', 11),
('9', '2', '4', 'Kate', 10),
('10', '3', '5', 'Peter', 8),
('11', '3', '5', 'Sergey', 9),
('12', '3', '6', 'Olga', 12),
('13', '3', '6', 'Maria', 14),
('14', '4', '7', 'Irina', 2),
('15', '4', '7', 'Grit', 10),
('16', '4', '7', 'Vanessa', 16),
('17', '5', '8', 'Sascha', 21),
('18', '5', '8', 'Ben', 22),
('19', '6', '9', 'Jessy', 19),
('20', '6', '9', 'Ann', 18);

*/


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
   
   