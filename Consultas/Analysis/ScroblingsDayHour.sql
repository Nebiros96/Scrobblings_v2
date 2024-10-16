-- Consulta de prueba para traer total de canciones escuchadas por hora y día de la semana
SELECT
	Hour,
	WeekDay,
	COUNT(*) AS Reproducciones,
	ROUND(CAST(COUNT(*)AS FLOAT)/CAST(COUNT(DISTINCT(Year_Month_Day))AS DECIMAL(16,2)),2) AS rep_per_day
FROM Clean_LastfmData
GROUP BY 
	WeekDay, Hour
ORDER BY 
	Hour ASC, WeekDay ASC;