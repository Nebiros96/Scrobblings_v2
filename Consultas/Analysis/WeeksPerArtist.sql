-- Weeks per Artist
/*
Número de semanas distintas por artista
Set datefirst 1 toma lunes como primer día de la semana
*/
SET DATEFIRST 1;

SELECT
	Artist,
	-- DATEPART(WEEK, Fecha_GMT) AS NumSemana,
	-- DATEPART(YEAR, Fecha_GMT) As Year,
	--CONCAT(DATEPART(YEAR, Fecha_GMT), DATEPART(WEEK, Fecha_GMT)) AS Concatenacion,
	COUNT(DISTINCT(CONCAT(DATEPART(YEAR, Fecha_GMT), DATEPART(WEEK, Fecha_GMT)))) AS Weeks,
	COUNT(*) AS Scrobblings,
	CAST(COUNT(*)/COUNT(DISTINCT(CONCAT(DATEPART(YEAR, Fecha_GMT), DATEPART(WEEK, Fecha_GMT)))) AS FLOAT) AS ScrobblingsPerWeel
FROM
	Scrobblings_fix
GROUP BY
	Artist
ORDER BY
	Weeks DESC,
	Scrobblings DESC;