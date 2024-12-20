/*
Racha de d�as consecutivas escuchando un mismo artista
PD: Se repite el artista en casos de encontrar m�s de una racha
*/
WITH Agrupacion AS (
    SELECT 
        Artist, 
        CAST(Fecha_GMT AS DATE) AS Date_fix,
        COUNT(*) AS Scrobblings,
        LAG(CAST(Fecha_GMT AS DATE), 1) OVER(PARTITION BY Artist ORDER BY CAST(Fecha_GMT AS DATE)) AS LastDate
    FROM Clean_LastfmData
    GROUP BY Artist, CAST(Fecha_GMT AS DATE)
), Bandera AS ( -- Bandera se entiende como el grupo de d�as 
    SELECT
        *,
        DATEDIFF(DAY, LastDate, Date_fix) AS Days_diff,
        SUM(CASE WHEN DATEDIFF(DAY, LastDate, Date_fix) > 1 THEN 1 ELSE 0 END) OVER(PARTITION BY Artist ORDER BY Date_fix) AS Bandera
    FROM Agrupacion
)

SELECT 
    Artist,
    -- Bandera,
    MIN(Date_fix) AS FechaInicio,
    MAX(Date_fix) AS FechaFin,
    COUNT(*) AS CantidadDias,
	SUM(Scrobblings) AS Scrobblings
FROM Bandera
-- WHERE Artist = 'Grimes' -- Para ver todas las rachas de un artista en espec�fico # LINEA COMENTADA para ver todo
GROUP BY Artist, Bandera
HAVING COUNT(*) > 1
ORDER BY CantidadDias DESC, Scrobblings DESC;

-- con artista espec�fico
WITH Agrupacion AS (
    SELECT 
        Artist, 
        CAST(Fecha_GMT AS DATE) AS Date_fix,
        COUNT(*) AS Scrobblings,
        LAG(CAST(Fecha_GMT AS DATE), 1) OVER(PARTITION BY Artist ORDER BY CAST(Fecha_GMT AS DATE)) AS LastDate
    FROM Clean_LastfmData
    GROUP BY Artist, CAST(Fecha_GMT AS DATE)
), Bandera AS (
    SELECT
        *,
        DATEDIFF(DAY, LastDate, Date_fix) AS Days_diff,
        SUM(CASE WHEN DATEDIFF(DAY, LastDate, Date_fix) > 1 THEN 1 ELSE 0 END) OVER(PARTITION BY Artist ORDER BY Date_fix) AS Bandera
    FROM Agrupacion
), MaxDias AS (
    SELECT TOP 1
        Artist,
        Bandera,
        MIN(Date_fix) AS FechaInicio,
        MAX(Date_fix) AS FechaFin,
        COUNT(*) AS CantidadDias,
		SUM(Scrobblings) AS Listens
    FROM Bandera
    WHERE Artist = N'Madonna' --Artista a seleccionar
    GROUP BY Artist, Bandera
    ORDER BY CantidadDias DESC
)
SELECT 
	ROW_NUMBER() OVER(ORDER BY B.Date_fix ASC) AS DayN,
    B.Artist,
    B.Date_fix AS Fecha,
    B.Scrobblings
FROM Bandera AS B
INNER JOIN MaxDias AS M ON B.Artist = M.Artist AND B.Bandera = M.Bandera
ORDER BY B.Date_fix ASC;