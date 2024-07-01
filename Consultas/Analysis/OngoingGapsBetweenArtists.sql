-- Ongoing gaps between artists
/*
última fecha menos la última reproducción
*/
SELECT
	Artist, 
	CAST(MIN(Fecha_GMT) AS DATE) AS FirstScrobbling,
	CAST(MAX(Fecha_GMT) AS DATE) AS LastScrobbling,
	DATEDIFF(DAY, CAST(MAX(Fecha_GMT) AS DATE), CAST(GETDATE() AS DATE)) AS DaysSinceLastScrobbling,
	ROUND(CAST(DATEDIFF(DAY, MAX(Fecha_GMT), GETDATE()) AS FLOAT) / 365.25, 1) AS Years,
	COUNT(*) AS Scrobblings
FROM
	Scrobblings_fix
GROUP BY
	Artist
ORDER BY
	DaysSinceLastScrobbling DESC;
