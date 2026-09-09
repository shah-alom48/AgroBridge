/* =====================================================================
   Restore script for AgroBridgeDB.bak
   -------------------------------------------------------------------
   Before running:
   1. Copy AgroBridgeDB.bak to a folder the SQL Server service account
      can read (usually the default backup folder on the SERVER, not
      your local machine if SSMS is connecting to a remote instance).
   2. Update @BackupFile below to the FULL PATH of the .bak file.
   3. Update @DataPath / @LogPath to a valid, writable folder on the
      server (where SQL Server keeps its data/log files).
   4. Update @DatabaseName if you want a different name than
      AgroBridgeDB.
   ===================================================================== */

USE master;
GO

DECLARE @BackupFile   NVARCHAR(500) = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\AgroBridgeDB.bak';
DECLARE @DatabaseName NVARCHAR(128) = N'AgroBridgeDB';
DECLARE @DataPath     NVARCHAR(500) = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\';
DECLARE @LogPath      NVARCHAR(500) = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\';

/* -----------------------------------------------------------------
   STEP 1 (optional but recommended): inspect the logical file names
   inside the backup. Run just this block first, check the results,
   then fill in @LogicalDataName / @LogicalLogName below if they
   differ from the defaults guessed here.
   ----------------------------------------------------------------- */
RESTORE FILELISTONLY
FROM DISK = @BackupFile;
GO

/* -----------------------------------------------------------------
   STEP 2: run the actual restore.
   NOTE: Re-declare the variables here since GO resets the batch scope.
   Adjust @LogicalDataName / @LogicalLogName to match STEP 1's output
   (the "Logical Name" column) if needed -- common defaults shown.
   ----------------------------------------------------------------- */
DECLARE @BackupFile     NVARCHAR(500) = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\AgroBridgeDB.bak';
DECLARE @DatabaseName   NVARCHAR(128) = N'AgroBridgeDB';
DECLARE @DataPath       NVARCHAR(500) = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\';
DECLARE @LogPath        NVARCHAR(500) = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\';
DECLARE @LogicalDataName NVARCHAR(128) = N'AgroBridgeDB';       -- adjust from FILELISTONLY output
DECLARE @LogicalLogName  NVARCHAR(128) = N'AgroBridgeDB_log';   -- adjust from FILELISTONLY output

DECLARE @sql NVARCHAR(MAX) = N'
RESTORE DATABASE ' + QUOTENAME(@DatabaseName) + N'
FROM DISK = N''' + @BackupFile + N'''
WITH MOVE N''' + @LogicalDataName + N''' TO N''' + @DataPath + @DatabaseName + N'.mdf'',
     MOVE N''' + @LogicalLogName  + N''' TO N''' + @LogPath  + @DatabaseName + N'_log.ldf'',
     REPLACE,
     STATS = 10;';

PRINT @sql;
EXEC sp_executesql @sql;
GO

/* -----------------------------------------------------------------
   STEP 3: quick sanity check
   ----------------------------------------------------------------- */
USE AgroBridgeDB;
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO
