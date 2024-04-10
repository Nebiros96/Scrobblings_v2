-- Borramos e importamos el csv a SQL Server con el nombre de [Brenoritvrezork]
DROP TABLE Brenoritvrezork;
-- Leemos datos del csv importado y eliminamos fechas nulas
SELECT * FROM Brenoritvrezork;

DELETE FROM Brenoritvrezork
WHERE Fecha IS NULL;

-- Borramos datos sin eliminar tabla
TRUNCATE TABLE Scrobblings_fix;

-- Insertamos nueva data
INSERT INTO Scrobblings_fix
SELECT 
[Artist],
[Album],
[Song],
[Fecha],
	DATEADD(HOUR, -5, Fecha) AS Fecha_GMT,
	DATEPART(YEAR, fecha) [Year],
	DATEPART(QUARTER, fecha) [Quarter],
	DATEPART(MONTH, fecha) [Month],
	DATEPART(DAY, fecha) [Day],
	DATEPART(HOUR, fecha) [Hour],
	FORMAT(Fecha, 'yyyy-MM') AS Year_Month,
	FORMAT(Fecha, 'yyyy-MM-dd') AS Year_Month_Day,
	DATENAME(WEEKDAY, Fecha) AS [WeekDay]
FROM [musica_julian].[dbo].[Brenoritvrezork];

-- Leemos
SELECT * FROM Scrobblings_fix;