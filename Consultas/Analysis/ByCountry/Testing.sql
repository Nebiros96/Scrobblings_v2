SELECT 
    A.Origen,
	COUNT(DISTINCT C.Artist) AS NumArtists,
	COUNT(*) AS Scrobblings,
	CAST(COUNT(*) * 1.0  / SUM(COUNT(*)) OVER () AS DECIMAL (5,3)) AS Porcentaje
FROM Clean_LastfmData AS C
LEFT JOIN ArtistsByCountry AS A
    ON C.Artist = A.Artist
GROUP BY 
	A.Origen
ORDER BY
	Scrobblings DESC