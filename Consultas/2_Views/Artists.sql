CREATE OR ALTER VIEW Artists AS 
SELECT
	Artist,
	MIN(Fecha_GMT) AS Min_fecha_full,
	MIN(Year_Month_Day) as Min_fecha
FROM Scrobblings_fix
GROUP BY
	Artist;

SELECT * FROM Artists;