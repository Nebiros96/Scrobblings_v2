-- New artists in a single month
WITH ArtistsFirstMonth AS (
    SELECT
        Artist,
        MIN(Year_Month) AS FirstMonth
    FROM
        Clean_LastfmData
    GROUP BY
        Artist
), -- Esta CTE Calcula los artistas distintos
ArtistsPerMonth AS (
    SELECT
        Year_Month,
        COUNT(DISTINCT Artist) AS TotalArtists
    FROM
        Clean_LastfmData
    GROUP BY
        Year_Month
)
SELECT
    afm.FirstMonth,
    COUNT(DISTINCT afm.Artist) AS Debutantes,
    apm.TotalArtists,
	ROUND(CAST(COUNT(DISTINCT afm.Artist) * 1.0 / apm.TotalArtists AS FLOAT), 2) AS Ratio
FROM
    ArtistsFirstMonth AS afm
LEFT JOIN
    ArtistsPerMonth AS apm ON afm.FirstMonth = apm.Year_Month
GROUP BY
    afm.FirstMonth, apm.TotalArtists
ORDER BY
    afm.FirstMonth;