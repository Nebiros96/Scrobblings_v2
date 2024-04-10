-- Consulta para traer artistas con más apariciones en un Top N y datos adicionales 
WITH Monthly_Records AS 
	(
	SELECT 
		Year_Month, 
		Artist, 
		COUNT(Artist) AS Reps
	FROM 
		Scrobblings_fix 
	GROUP BY 
		Artist, 
		Year_Month
	),
Nested_cte AS (
SELECT 
	Year_Month, Artist, Reps, 
	ROW_NUMBER() OVER(PARTITION BY Year_Month ORDER BY Reps DESC) AS RN
FROM
	Monthly_Records
WHERE 
	Year_Month IS NOT NULL
GROUP BY 
	Year_Month, Artist, Reps
),
SubNested_cte AS (
SELECT
	Artist, MIN(RN) AS Best_rank, COUNT(Artist) AS Times_into_top5, SUM(Reps) AS Plays_in_top5, MAX(Year_Month) AS Last_Month, MAX(Reps) Plays_record
FROM
	Nested_cte
WHERE RN < 6
GROUP BY 
	Artist
	)

SELECT * FROM SubNested_cte
ORDER BY 
	Times_into_top5 DESC

