-- Rachas consecutivas de días escuchando música
WITH LagColumn AS (
    SELECT 
        Year_Month_Day,
        COUNT(*) AS Listens,
        LAG(Year_Month_Day, 1) OVER (ORDER BY Year_Month_Day ASC) AS PreviousDay 
    FROM Clean_LastfmData
    GROUP BY Year_Month_Day
),
Agrupacion AS (
    SELECT
        Year_Month_Day,
        Listens,
        PreviousDay,
        DATEDIFF(DAY, PreviousDay, Year_Month_Day) AS DayDiff,
        SUM(CASE WHEN DATEDIFF(DAY, PreviousDay, Year_Month_Day) != 1 THEN 1 ELSE 0 END) OVER (ORDER BY Year_Month_Day) AS Bandera
    FROM LagColumn
)
SELECT 
    MIN(Year_Month_Day) AS StartDate,
    MAX(Year_Month_Day) AS EndDate,
    COUNT(*) AS StreakDays,
	SUM(Listens) AS Listens,
	SUM(Listens)/COUNT(*) AS ListensPerDay
FROM Agrupacion
GROUP BY Bandera
HAVING COUNT(*) > 6
ORDER BY StreakDays DESC, Listens DESC;
