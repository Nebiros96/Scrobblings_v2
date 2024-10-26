/*
Best_rank: Mejor posición en Scrobblings del artista en un mes
Times_into_top5: Cantidad de veces en el top 5 por mes
Plays_in_top5: Scrobblings dentro de las veces que estuvo en el top 5
Last_Month: Último mes que hizo parte de un top 5
Plays_record: Mayor cantidad de Scrobblings en un solo mes
*/
WITH Monthly_Records AS 
	(
	SELECT 
		Year_Month, 
		Artist, 
		COUNT(Artist) AS Reps
	FROM 
		Clean_LastfmData 
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