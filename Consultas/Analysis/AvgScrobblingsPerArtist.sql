/*
Promedio de Scrobblings por canción por artista
*/
SELECT
	Artist,
	COUNT(*) AS Scrobblings,
	COUNT(DISTINCT Song) AS Songs,
	COUNT(*)/COUNT(DISTINCT Song) AS ScrobblingsPerSong
FROM
	Clean_LastfmData
GROUP BY
	Artist
HAVING
	COUNT(*)/COUNT(DISTINCT Song) >= 10
ORDER BY
	ScrobblingsPerSong DESC;