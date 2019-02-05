<p>Оконные функции.
Вывести список пользователей в формате userId, movieId, normed_rating, avg_rating где
userId, movieId - без изменения
normed_rating=(r - r_min)/(r_max - r_min), где r_min и r_max соответственно минимально и максимальное значение рейтинга у данного пользователя
avg_rating - среднее значение рейтинга у данного пользователя
Вывести первые 30 таких записей
</p>

<pre>
SELECT 	userId, 
		movieId, 
		((rating - MIN(rating) OVER (PARTITION BY userId)) / (MIN(rating) OVER (PARTITION BY userId) - MAX(rating) OVER (PARTITION BY userId)))  AS normed_rating, 
		AVG(rating) OVER (PARTITION BY userId) avg_rating 
FROM ratings 
LIMIT 30;
</pre>




<img src="hw3_1.PNG" alt="">
<br/><br/>
