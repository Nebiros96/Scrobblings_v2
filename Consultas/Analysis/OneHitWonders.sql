-- One hit wonders
SELECT
	Artist,
	COUNT(*) AS Scrobblings,
	COUNT(DISTINCT Song) AS Songs
FROM
	Clean_LastfmData
GROUP BY
	Artist
HAVING COUNT(DISTINCT Song) = 1
ORDER BY
	Scrobblings DESC