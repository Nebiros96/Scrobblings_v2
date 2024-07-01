-- One hit wonders
SELECT
	Artist,
	COUNT(*) AS Scrobblings,
	COUNT(DISTINCT Song) AS Songs
FROM
	Scrobblings_fix
GROUP BY
	Artist
HAVING COUNT(DISTINCT Song) = 1
ORDER BY
	Scrobblings DESC