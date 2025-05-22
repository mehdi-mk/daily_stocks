@echo off
REM --- Configuration ---
SET PYTHON_EXE_PATH="C:\Python39\python.exe"
SET PYTHON_SCRIPT_PATH="C:\path\to\your\fetch_fmp_data.py"
SET SQL_SCRIPT_DAILY_DATA="C:\path\to\your\LOAD_fm_daily_stock_data.sql"
SET SQL_SCRIPT_PROFILES="C:\path\to\your\LOAD_company_profiles.sql"

SET PG_PSQL_PATH="C:\Program Files\PostgreSQL\16\bin\psql.exe"
SET DB_USER=your_postgres_user
SET DB_NAME=your_database_name
REM For password, consider using %APPDATA%\postgresql\pgpass.conf or PGPASSWORD environment variable
REM See: https://www.postgresql.org/docs/current/libpq-pgpass.html

SET LOG_FILE="C:\path\to\your\daily_load_fmp.log"

echo --- Starting daily FMP data load: %date% %time% --- >> "%LOG_FILE%"

REM 1. Run Python script to fetch data
echo Running Python script to fetch CSVs... >> "%LOG_FILE%"
%PYTHON_EXE_PATH% "%PYTHON_SCRIPT_PATH%" >> "%LOG_FILE%" 2>>&1

REM 2. Load daily stock data into PostgreSQL
echo Loading daily_stock_data.csv into PostgreSQL... >> "%LOG_FILE%"
"%PG_PSQL_PATH%" -U %DB_USER% -d %DB_NAME% -a -f "%SQL_SCRIPT_DAILY_DATA%" >> "%LOG_FILE%" 2>>&1

REM 3. Load company profiles into PostgreSQL
echo Loading company_profiles.csv into PostgreSQL... >> "%LOG_FILE%"
"%PG_PSQL_PATH%" -U %DB_USER% -d %DB_NAME% -a -f "%SQL_SCRIPT_PROFILES%" >> "%LOG_FILE%" 2>>&1

echo --- Daily FMP data load finished: %date% %time% --- >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"