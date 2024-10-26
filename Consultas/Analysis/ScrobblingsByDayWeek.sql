-- Scrobblings por día de la semana 
WITH TotalScobblingsPerWeekDay AS (
    SELECT
        WeekDay,
        COUNT(*) AS TotalScobblings
    FROM 
        Clean_LastfmData
    GROUP BY
        WeekDay
),
UniqueDaysPerWeekDay AS (
    SELECT
        WeekDay,
        COUNT(DISTINCT Year_Month_Day) AS UniqueDays
    FROM 
        Clean_LastfmData
    GROUP BY
        WeekDay
)
SELECT
    u.WeekDay,
    u.UniqueDays,
    t.TotalScobblings,
    t.TotalScobblings / u.UniqueDays AS AvgScrobblingsPerDay
FROM 
    UniqueDaysPerWeekDay u
INNER JOIN TotalScobblingsPerWeekDay AS t ON u.WeekDay = t.WeekDay
ORDER BY
    UniqueDays DESC;