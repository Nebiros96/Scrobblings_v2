BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Eliminamos tabla origen existente
    IF OBJECT_ID('Rawlastfm', 'U') IS NOT NULL
    BEGIN
        DROP TABLE Rawlastfm;
    END

    -- 2. Creamos esquema inicial de la tabla a importar en el csv
    CREATE TABLE Rawlastfm (
        Artist NVARCHAR(255),
        Album NVARCHAR(500),
        Song NVARCHAR(500),
        Fecha DATETIME
    );

    -- 3. BULK INSERT para importar el archivo CSV
    BULK INSERT Rawlastfm
    FROM 'D:\OneDrive\Documentos\Data Analysis\Scrobblings\Brenoritvrezork.csv'
    WITH (
        FIELDTERMINATOR = ';',
        FIRSTROW = 2,  -- Si la primera fila tiene los nombres de columnas
        CODEPAGE = '65001',  -- Para UTF-8
        TABLOCK
    );

    -- 4. Eliminamos filas donde la columna Fecha es NULL
    DELETE FROM Rawlastfm
    WHERE Fecha IS NULL;

    -- 5. Agregamos nueva columna fecha gmt-5
    ALTER TABLE Rawlastfm
    ADD Fecha_GMT DATETIME;

    -- 6. Ejecutamos query para la columna previamente agregada
    EXEC sp_executesql N'
    UPDATE Rawlastfm
    SET Fecha_GMT = DATEADD(HOUR, -5, Fecha)
    WHERE Fecha IS NOT NULL;
    ';

    -- 7. Truncamos Scrobblings_fix antes de insertar la nueva data
    TRUNCATE TABLE Clean_LastfmData;

    -- 8. Insertamos los datos procesados en Scrobblings_fix
    INSERT INTO Clean_LastfmData 
		(Artist, Album, Song, Fecha, [Fecha_GMT], [Year], [Quarter], [Month], [Day], [Hour], Year_Month, Year_Month_Day, [WeekDay])
    SELECT 
        [Artist],
        [Album],
        [Song],
        [Fecha], 
        [Fecha_GMT],
        DATEPART(YEAR, Fecha_GMT) AS [Year],
        DATEPART(QUARTER, Fecha_GMT) AS [Quarter],
        DATEPART(MONTH, Fecha_GMT) AS [Month],
        DATEPART(DAY, Fecha_GMT) AS [Day],
        DATEPART(HOUR, Fecha_GMT) AS [Hour],
        FORMAT(Fecha_GMT, 'yyyy-MM') AS Year_Month,
        FORMAT(Fecha_GMT, 'yyyy-MM-dd') AS Year_Month_Day,
        DATENAME(WEEKDAY, Fecha_GMT) AS [WeekDay]
    FROM [musica_julian].[dbo].Rawlastfm;

    -- 9. Actualizamos la columna RowNum en Clean_LastfmData
    WITH CTE AS (
        SELECT *, ROW_NUMBER() OVER(ORDER BY Fecha_GMT ASC) AS NewRowNum
        FROM Clean_LastfmData
    )
    UPDATE CTE
    SET RowNum = NewRowNum;

    -- 10. Ejecutamos el SP para hacer limpieza de datos
    EXEC dbo.cleaning_scrobblings;

    -- 11. Confirmamos transacción si todo ha ido bien
    COMMIT TRANSACTION;
    PRINT 'Todo se ejecutó en orden';

END TRY
BEGIN CATCH
    -- ROLLBACK si falla
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