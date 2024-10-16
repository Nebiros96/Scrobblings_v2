-- Racha por artista (repitiendo)
WITH PrevArtist AS (
SELECT
	Artist,
	RowNum,
	Fecha_GMT,
	LAG(Artist, 1) OVER(ORDER BY RowNum ASC) AS PreviousArtist,
    CASE WHEN LAG(Artist, 1) OVER(ORDER BY RowNum ASC) = Artist THEN 0 ELSE 1 END AS ArtistChange
FROM Clean_LastfmData),
Bandera AS (
SELECT
	Artist,
	RowNum,
	Fecha_GMT,
	SUM(ArtistChange) OVER(ORDER BY RowNum ASC) AS GroupID
FROM PrevArtist)
SELECT
	Artist,
	COUNT(*) AS Streak,
	MIN(Fecha_GMT) AS DateStart,
	MAX(Fecha_GMT) AS DateFinish,
	MIN(RowNum) AS StartStreak,
	MAX(RowNum) AS FinishStreak
FROM Bandera
GROUP BY Artist, GroupID
HAVING COUNT(*) >= 5
ORDER BY Streak DESC, FinishStreak ASC;

-- Consulta SIN repetir Artistas
WITH PrevArtist AS (
    SELECT
        Artist,
        RowNum,
        Fecha_GMT,
        LAG(Artist, 1) OVER(ORDER BY RowNum ASC) AS PreviousArtist,
        CASE WHEN LAG(Artist, 1) OVER(ORDER BY RowNum ASC) = Artist THEN 0 ELSE 1 END AS ArtistChange
    FROM Clean_LastfmData
),
Bandera AS (
    SELECT
        Artist,
        RowNum,
        Fecha_GMT,
        SUM(ArtistChange) OVER(ORDER BY RowNum ASC) AS GroupID
    FROM PrevArtist
),
Streaks AS (
    SELECT
        Artist,
        COUNT(*) AS Streak,
        MIN(Fecha_GMT) AS DateStart,
        MAX(Fecha_GMT) AS DateFinish,
        MIN(RowNum) AS StartStreak,
        MAX(RowNum) AS FinishStreak,
        ROW_NUMBER() OVER(PARTITION BY Artist ORDER BY COUNT(*) DESC) AS RN -- Ranking
    FROM Bandera
    GROUP BY Artist, GroupID
    HAVING COUNT(*) >= 5
)
SELECT
	Artist,
	Streak,
	DateStart,
	DateFinish,
	StartStreak,
	FinishStreak
FROM Streaks
WHERE RN = 1
ORDER BY Streak DESC, FinishStreak ASC;
