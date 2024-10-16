-- Avg scrobbles per track
SELECT
	Artist,
	COUNT(*) AS Scrobblings,
	COUNT(DISTINCT Song) AS Songs,
	COUNT(*)/COUNT(DISTINCT Song) AS ScrobblingsPerSong
FROM
	Clean_LastfmData
GROUP BY
	Artist
ORDER BY
	ScrobblingsPerSong DESC;