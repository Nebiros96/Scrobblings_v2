-- Consulta de prueba para traer total de canciones escuchadas por hora y día de la semana

WITH Group_by_custom AS
	(
	SELECT *,
		DATEPART(YEAR, fecha) [Year],
		DATEPART(QUARTER, fecha) [Quarter],
		DATEPART(MONTH, fecha) [Month],
		DATEPART(DAY, fecha) [Day],
		DATEPART(HOUR, fecha) [Hour],
		FORMAT(Fecha, 'yyyy-MM') AS Year_Month,
		FORMAT(Fecha, 'yyyy-MM-dd') AS Year_Month_Day,
		DATENAME(WEEKDAY, Fecha) AS [WeekDay]
	FROM 
		Brenoritvrezork
	)
SELECT 
	[Hour], 
	[WeekDay], 
	COUNT(Artist) AS Reproducciones,
	ROUND(CAST(COUNT(Artist)AS FLOAT)/CAST(COUNT(DISTINCT(Year_Month_Day))AS DECIMAL(16,2)),2) AS rep_per_day
FROM 
	Group_by_custom 
WHERE 
	Year_Month_Day IS NOT NULL
GROUP BY 
	[WeekDay], [Hour]
ORDER BY 
	Reproducciones DESC;
