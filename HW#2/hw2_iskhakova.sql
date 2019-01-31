---1.1---

SELECT * FROM ratings LIMIT 10;


---1.2---


SELECT * FROM links 
WHERE imdbid LIKE '%42' AND
	  movieid BETWEEN 100 AND 1000
LIMIT 10;


---2.1---

SELECT DISTINCT imdbid 			-- distinct можно было не использовать
FROM links 
INNER JOIN ratings
	ON links.movieid = ratings.movieid
WHERE ratings.rating = 5
LIMIT 10;


---3.1---

SELECT COUNT(links.movieid)
FROM links
LEFT JOIN ratings
	ON links.movieid = ratings.movieid 
WHERE ratings.rating IS NULL
LIMIT 10;


---3.2---

SELECT userid
FROM ratings
GROUP BY userid
HAVING AVG(rating)>3.5
ORDER BY AVG(rating) DESC
LIMIT 10;


---4.1---

SELECT imdbid
FROM links
WHERE links.movieid IN 
	(
	SELECT ratings.movieid
	FROM ratings
	GROUP BY movieid
	HAVING avg(rating) > 3.5
	)
LIMIT 10;

---4.2---

WITH new_table
AS	(SELECT userid, avg(rating) AS user_average
	FROM ratings
	GROUP BY userid
	HAVING COUNT(rating) > 10)
	
SELECT AVG(user_average) as average
FROM new_table;
