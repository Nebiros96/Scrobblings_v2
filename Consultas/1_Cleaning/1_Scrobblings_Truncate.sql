-- Borramos e importamos el csv a SQL Server con el nombre de [Brenoritvrezork]
DROP TABLE Brenoritvrezork;
-- Leemos datos del csv importado y eliminamos fechas nulas
SELECT * FROM Brenoritvrezork;

DELETE FROM Brenoritvrezork
WHERE Fecha IS NULL;

-- Agregamos la fecha con GMT-5 
ALTER TABLE Brenoritvrezork
ADD Fecha_GMT datetime;
-- Actualizar la nueva columna con los valores calculados
UPDATE Brenoritvrezork
SET Fecha_GMT = DATEADD(HOUR, -5, Fecha);



-- Borramos datos sin eliminar tabla
TRUNCATE TABLE Scrobblings_fix;

-- Insertamos nueva data
INSERT INTO Scrobblings_fix (Artist, Album, Song, Fecha, [Fecha_GMT], [Year], [Quarter], [Month], [Day], [Hour], Year_Month, Year_Month_Day, [WeekDay])
SELECT 
    [Artist],
    [Album],
    [Song],
    [Fecha], 
	[Fecha_GMT],
    DATEPART(YEAR, Fecha_GMT) AS [Year],
    DATEPART(QUARTER, Fecha_GMT) AS [Quarter],
    DATEPART(MONTH, Fecha_GMT) AS [Month],
    DATEPART(DAY, Fecha_GMT) AS [Day],
    DATEPART(HOUR, Fecha_GMT) AS [Hour],
    FORMAT(Fecha_GMT, 'yyyy-MM') AS Year_Month,
    FORMAT(Fecha_GMT, 'yyyy-MM-dd') AS Year_Month_Day,
    DATENAME(WEEKDAY, Fecha_GMT) AS [WeekDay]
FROM [musica_julian].[dbo].[Brenoritvrezork];

-- Leemos
SELECT * FROM Scrobblings_fix;


/* ESQUEMAS
-- Scrobblings_fix
CREATE TABLE Scrobblings_fix (
    Artist NVARCHAR(255),
    Album NVARCHAR(255),
    Song NVARCHAR(255),
    Fecha DATETIME,
    Fecha_GMT DATETIME,
    [Year] INT,
    [Quarter] INT,
    [Month] INT,
    [Day] INT,
    [Hour] INT,
    Year_Month NVARCHAR(7),
    Year_Month_Day NVARCHAR(10),
    [WeekDay] NVARCHAR(50),
	[RowNum] INT
);

*/
-- TRANSACCIÓN
BEGIN TRANSACTION;
TRUNCATE TABLE Scrobblings_fix;
-- Insertar datos
INSERT INTO Scrobblings_fix (Artist, Album, Song, Fecha, [Fecha_GMT], [Year], [Quarter], [Month], [Day], [Hour], Year_Month, Year_Month_Day, [WeekDay])
SELECT 
    [Artist],
    [Album],
    [Song],
    [Fecha], 
	[Fecha_GMT],
    DATEPART(YEAR, Fecha_GMT) AS [Year],
    DATEPART(QUARTER, Fecha_GMT) AS [Quarter],
    DATEPART(MONTH, Fecha_GMT) AS [Month],
    DATEPART(DAY, Fecha_GMT) AS [Day],
    DATEPART(HOUR, Fecha_GMT) AS [Hour],
    FORMAT(Fecha_GMT, 'yyyy-MM') AS Year_Month,
    FORMAT(Fecha_GMT, 'yyyy-MM-dd') AS Year_Month_Day,
    DATENAME(WEEKDAY, Fecha_GMT) AS [WeekDay]
FROM [musica_julian].[dbo].[Brenoritvrezork];
-- Actualizar RowNum
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER(ORDER BY Fecha_GMT ASC) AS NewRowNum
    FROM Scrobblings_fix
)
UPDATE CTE
SET RowNum = NewRowNum;
COMMIT TRANSACTION;
