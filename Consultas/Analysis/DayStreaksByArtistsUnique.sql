WITH Agrupacion AS (
    SELECT 
        Artist, 
        CAST(Fecha_GMT AS DATE) AS Date_fix,
        COUNT(*) AS Scrobblings,
        LAG(CAST(Fecha_GMT AS DATE), 1) OVER(PARTITION BY Artist ORDER BY CAST(Fecha_GMT AS DATE)) AS LastDate
    FROM Scrobblings_fix
    GROUP BY Artist, CAST(Fecha_GMT AS DATE)
), Bandera AS ( -- Bandera se entiende como el grupo de días 
    SELECT
        *,
        DATEDIFF(DAY, LastDate, Date_fix) AS Days_diff,
        SUM(CASE WHEN DATEDIFF(DAY, LastDate, Date_fix) > 1 THEN 1 ELSE 0 END) OVER(PARTITION BY Artist ORDER BY Date_fix) AS Bandera
    FROM Agrupacion
), Rachas AS (
    SELECT 
        Artist,
        MIN(Date_fix) AS FechaInicio,
        MAX(Date_fix) AS FechaFin,
        COUNT(*) AS CantidadDias,
        SUM(Scrobblings) AS Listens,
        ROW_NUMBER() OVER (PARTITION BY Artist ORDER BY COUNT(*) DESC, SUM(Scrobblings) DESC) AS RowNum
    FROM Bandera
    GROUP BY Artist, Bandera
    HAVING COUNT(*) > 1
)
SELECT 
    Artist,
    FechaInicio,
    FechaFin,
    CantidadDias,
    Listens
FROM Rachas
WHERE RowNum = 1
ORDER BY CantidadDias DESC, Listens DESC;
