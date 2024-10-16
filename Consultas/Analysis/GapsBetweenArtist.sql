-- Largest time passed between two scrobbles of the same artist
WITH ScrobblingsWithDaysBetween AS (
    SELECT
        Artist,
        CAST(Fecha_GMT AS DATE) AS Fecha,
        LAG(CAST(Fecha_GMT AS DATE), 1) OVER(PARTITION BY Artist
            ORDER BY CAST(Fecha_GMT AS DATE)) AS EndDate,
        DATEDIFF(DAY, LAG(CAST(Fecha_GMT AS DATE), 1) OVER(PARTITION BY Artist
            ORDER BY CAST(Fecha_GMT AS DATE)), CAST(Fecha_GMT AS DATE)) AS DaysBetween
    FROM Clean_LastfmData
	GROUP BY
	Artist,
	Fecha_GMT
	--HAVING COUNT(*) > 1
),
RankedScrobblings AS (
    SELECT
        Artist,
        Fecha,
        EndDate,
        DaysBetween,
        ROW_NUMBER() OVER(PARTITION BY Artist ORDER BY DaysBetween DESC) AS RowNum
    FROM ScrobblingsWithDaysBetween
)
SELECT
    Artist,
    Fecha,
    EndDate,
    DaysBetween,
	ROUND(CAST(DaysBetween/365.25 AS FLOAT),1) AS YearsBetween
FROM RankedScrobblings
WHERE RowNum = 1 AND DaysBetween IS NOT NULL
ORDER BY DaysBetween DESC;