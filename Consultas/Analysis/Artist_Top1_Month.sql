-- Artista más escuchado por mes y porcentaje con respecto al total 
WITH TotalCounts AS (
    SELECT 
        Year_Month, 
        COUNT(*) AS TotalScrobblings
    FROM Scrobblings_fix 
    GROUP BY Year_Month
),
RankedArtists AS (
    SELECT 
        Year_Month,
        Artist, 
        COUNT(*) AS Scrobblings,
        ROW_NUMBER() OVER (PARTITION BY Year_Month ORDER BY COUNT(*) DESC) AS RowNum
    FROM Scrobblings_fix
    GROUP BY Year_Month, Artist
)
SELECT 
    R.Year_Month,
    R.Artist,
    R.Scrobblings,
    T.TotalScrobblings,
	ROUND(CAST(R.Scrobblings AS FLOAT)/(T.TotalScrobblings) * 100 ,2) AS Percentage_total
FROM RankedArtists AS R
JOIN TotalCounts AS T ON R.Year_Month = T.Year_Month
WHERE R.RowNum = 1
ORDER BY Percentage_total DESC;


