-- Racha por artista (repitiendo)
WITH PrevArtist AS (
SELECT
	Artist,
	Song,
	RowNum,
	Fecha_GMT,
	LAG(Artist, 1) OVER(ORDER BY RowNum ASC) AS PreviousArtist,
    CASE WHEN LAG(Artist, 1) OVER(ORDER BY RowNum ASC) = Artist THEN 0 ELSE 1 END AS ArtistChange
FROM Scrobblings_fix),
Bandera AS (
SELECT
	Artist,
	Song,
	RowNum,
	Fecha_GMT,
	SUM(ArtistChange) OVER(ORDER BY RowNum ASC) AS GroupID
FROM PrevArtist)
SELECT
	Artist,
	Song,
	COUNT(*) AS Streak,
	MIN(Fecha_GMT) AS DateStart,
	MAX(Fecha_GMT) AS DateFinish,
	MIN(RowNum) AS StartStreak,
	MAX(RowNum) AS FinishStreak
FROM Bandera
GROUP BY Artist, GroupID, Song
HAVING COUNT(*) >= 5
ORDER BY Streak DESC, FinishStreak ASC;