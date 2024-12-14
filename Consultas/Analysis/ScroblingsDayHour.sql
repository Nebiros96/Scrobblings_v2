-- Total de Scrobblings por día de la semana y hora.
SELECT
	Hour,
	WeekDay,
	COUNT(*) AS Scrobblings,
	ROUND(CAST(COUNT(*)AS FLOAT)/CAST(COUNT(DISTINCT(Year_Month_Day))AS DECIMAL(16,2)),2) AS rep_per_day
FROM Clean_LastfmData
-- WHERE Year = '2024'
GROUP BY 
	WeekDay, Hour
ORDER BY 
	Scrobblings ASC, WeekDay ASC;