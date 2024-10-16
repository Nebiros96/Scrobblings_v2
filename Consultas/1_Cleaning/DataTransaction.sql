SET XACT_ABORT ON;  -- cualquier error provoca ROLLBACK inmediato
BEGIN TRANSACTION;
BEGIN TRY
    -- 1. Eliminamos la tabla origen si existe
    IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Rawlastfm' AND type = 'U')
    BEGIN
        DROP TABLE dbo.Rawlastfm;
    END;

    -- 2. Creamos el esquema inicial de la tabla
    CREATE TABLE dbo.Rawlastfm (
        Artist NVARCHAR(255),
        Album NVARCHAR(500),
        Song NVARCHAR(500),
        Fecha DATETIME
    );

    -- 3. BULK INSERT para importar datos desde CSV
    BULK INSERT dbo.Rawlastfm
    FROM 'D:\OneDrive\Documentos\Data Analysis\Scrobblings\Brenoritvrezork.csv'
    WITH (
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2,
        CODEPAGE = '65001',  -- UTF-8
        TABLOCK,  -- Bloqueo de tabla para mejorar el rendimiento
        MAXERRORS = 10  -- Número máximo de errores permitidos
    );

    -- 4. Eliminamos filas con Fecha NULL para evitar errores futuros
    DELETE FROM dbo.Rawlastfm WHERE Fecha IS NULL;

    -- 5. Truncamos la tabla destino antes de la inserción
    TRUNCATE TABLE dbo.Clean_LastfmData;

    -- 6. Insertamos los datos en Clean_LastfmData y calculamos Fecha_GMT
    INSERT INTO dbo.Clean_LastfmData (
        Artist, Album, Song, Fecha, Fecha_GMT, [Year], [Quarter], [Month], 
        [Day], [Hour], Year_Month, Year_Month_Day, [WeekDay]
    )
    SELECT 
        Artist,
        Album,
        Song,
        Fecha,  -- Fecha original sin alteración
        DATEADD(HOUR, -5, Fecha) AS Fecha_GMT,  -- Fecha ajustada a GMT-5

        -- Ahora todas las columnas derivadas se basan en Fecha_GMT
        DATEPART(YEAR, DATEADD(HOUR, -5, Fecha)) AS [Year],
        DATEPART(QUARTER, DATEADD(HOUR, -5, Fecha)) AS [Quarter],
        DATEPART(MONTH, DATEADD(HOUR, -5, Fecha)) AS [Month],
        DATEPART(DAY, DATEADD(HOUR, -5, Fecha)) AS [Day],
        DATEPART(HOUR, DATEADD(HOUR, -5, Fecha)) AS [Hour],
        CONVERT(CHAR(7), DATEADD(HOUR, -5, Fecha), 120) AS Year_Month,
        CONVERT(CHAR(10), DATEADD(HOUR, -5, Fecha), 120) AS Year_Month_Day,
        DATENAME(WEEKDAY, DATEADD(HOUR, -5, Fecha)) AS [WeekDay]
    FROM dbo.Rawlastfm;

    -- 7. Actualizamos la columna RowNum usando CTE
    WITH CTE AS (
        SELECT *, ROW_NUMBER() OVER(ORDER BY Fecha_GMT ASC) AS NewRowNum
        FROM dbo.Clean_LastfmData
    )
    UPDATE CTE SET RowNum = NewRowNum;

    -- 8. Ejecutamos el SP de limpieza
    EXEC dbo.cleaning_scrobblings;

    -- 9. Confirmamos la transacción
    COMMIT TRANSACTION;
    PRINT 'Todo se ejecutó en orden';

END TRY
BEGIN CATCH
    -- ROLLBACK si ocurre un error
    ROLLBACK TRANSACTION;
    PRINT 'Falló la actualización. Se revertieron los cambios';

    -- Opcional: Mostrar el mensaje de error
    THROW;
END CATCH;

/* Configuraciones en caso de que onedrive falle
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
*/