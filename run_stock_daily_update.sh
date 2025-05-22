#!/bin/bash

# TODO: Set the absolute paths to your Python script and the queries to loading the tables
PYTHON_SCRIPT_PATH="/PATH/TO/stock_data_FMP_API.py"
SQL_SCRIPT_DAILY_DATA="/PATH/TO/LOAD_fm_daily_stock_data.sql" # Absolute path
SQL_SCRIPT_PROFILES="/PATH/TO/LOAD_company_profiles.sql"   # Absolute path

# TODO: Set the correct username and database name here
DB_USER="YOUR_POSTGRES_USER"
DB_NAME="YOUR_POSTGRES_NAME"
# For password, consider using ~/.pgpass file for automation: https://www.postgresql.org/docs/current/libpq-pgpass.html
# Basically, on macOS/Linux save the file "~/.pgpass" with this content: hostname:port:database:username:password
# Then give right permissions: chmod 600 ~/.pgpass

LOG_FILE="/Users/mehdik/daily_load_fmp.log" # For logging output

echo "=============================================" >> "${LOG_FILE}"
echo "--- Starting daily FMP data load: $(date) ---" >> "${LOG_FILE}"
echo "============================================="

# 1. Run Python script to fetch data

# TODO: Set the correct path for your Python
/PATH/TO/PYTHON/pyhon3 "${PYTHON_SCRIPT_PATH}" >> "${LOG_FILE}" 2>&1 # Or your specific python3 path

# 2. Load daily stock data into PostgreSQL

# TODO: Set the correct path for your PSQL
echo "Loading daily_stock_data.csv into PostgreSQL..." >> "${LOG_FILE}"
/PATH/TO/PSQL/psql -U "${DB_USER}" -d "${DB_NAME}" -f "${SQL_SCRIPT_DAILY_DATA}" >> "${LOG_FILE}" 2>&1

# 3. Load company profiles into PostgreSQL

# TODO: Set the correct path for your PSQL
echo "Loading company_profiles.csv into PostgreSQL..." >> "${LOG_FILE}"
/PATH/TO/PSQL/psql -U "${DB_USER}" -d "${DB_NAME}" -f "${SQL_SCRIPT_PROFILES}" >> "${LOG_FILE}" 2>&1

echo "--- Daily FMP data load finished: $(date) ---\n" >> "${LOG_FILE}"
echo "\n\n" >> "${LOG_FILE}"
