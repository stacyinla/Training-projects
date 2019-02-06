-----------------------"ВАША КОМАНДА СОЗДАНИЯ ТАБЛИЦЫ";---------------
CREATE TABLE IF NOT EXISTS keywords 
	(
	id INTEGER PRIMARY KEY, 
	tags VARCHAR
	);




	
---------------------"ВАША КОМАНДА ЗАЛИВКИ ДАННЫХ В ТАБЛИЦу";-------------------
\\copy keywords FROM '/usr/local/share/netology/raw_data/keywords.csv' DELIMITER ',' CSV HEADER	





----------------"ЗАПРОС3";---------------------
WITH top_rated AS
	(
	SELECT movieid, AVG(rating) AS avg_rating		--запрос1
	FROM	ratings
	GROUP BY movieid
	HAVING	COUNT(rating) > 50
	ORDER BY avg_rating DESC				
	)
SELECT 											--запрос2
	top_rated.movieid, 
	top_rated.avg_rating, 
	keywords.tags
INTO top_rated_tags	
FROM top_rated 
LEFT JOIN keywords
		ON top_rated.movieid = keywords.movieid
ORDER BY avg_rating DESC
;	





--------"ВАША КОМАНДА ВЫГРУЗКИ ТАБЛИЦЫ В ФАЙЛ"----------
\copy (SELECT * FROM top_rated_tags) TO 'top_rated_tags.csv' WITH CSV HEADER DELIMITER E'\t';
</pre>
