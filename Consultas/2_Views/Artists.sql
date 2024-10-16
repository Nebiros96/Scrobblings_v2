CREATE OR ALTER VIEW Artists AS 
SELECT
	Artist,
	MIN(Fecha_GMT) AS Min_fecha_full,
	MIN(Year_Month_Day) as Min_fecha
FROM Clean_LastfmData
GROUP BY
	Artist;
