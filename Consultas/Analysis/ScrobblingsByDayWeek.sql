-- Scrobblings por día de la semana (CON join)
SELECT
    s.WeekDay,
    COUNT(DISTINCT s.Year_Month_Day) AS UniqueDays,
    t.TotalScobblings,
	t.TotalScobblings/COUNT(DISTINCT s.Year_Month_Day) AS AVG_day
FROM 
    Clean_LastfmData s
INNER JOIN (
    SELECT
        WeekDay,
        COUNT(*) AS TotalScobblings
    FROM 
        Clean_LastfmData
    GROUP BY
        WeekDay
) AS t ON s.WeekDay = t.WeekDay
GROUP BY
    s.WeekDay, t.TotalScobblings
ORDER BY
    UniqueDays DESC;

-- lo mismo pero con CTE
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