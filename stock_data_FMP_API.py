import requests
import csv
import os
import platform

# --- Configuration ---
API_KEY = "YOUR_FMP_API_KEY" # Replace with your actual FMP API key

if platform.system() == "Windows":
	# IMPORTANT NOTE: Ensure this directory exists and PostgreSQL server user has read access
    OUTPUT_DIR = "C:/pgsql_staging/" 
else: # macOS / Linux
    OUTPUT_DIR = "/tmp/" # Because PostgreSQL server has access to the /tmp/ directory by default.


SYMBOLS_LIST = "MSFT,AAPL,NVDA,AMZN,GOOG,GOOGL,LLY,BRK.A,BRK.B,TSLA,AVGO,JPM,V,MA,NFLX,XOM,COST,UNH,HD,PG,ORCL,JNJ,ABBV,BAC,KO,PLTR,TMUS,CRM,PM,WFC,CSCO,CVX,IBM,ABT,GE,MCD,NOW,AXP,MS,ISRG,MRK,DIS,VZ,INTU,PEP,TMO,AMD,ADBE,CAT,TXN,AMGN,SYK,WMT"

############ File 1: Daily Share Values and Volumes ############
print("Fetching daily stock data...\n")
url_daily = f'https://financialmodelingprep.com/api/v3/quote/{SYMBOLS_LIST}?apikey={API_KEY}&datatype=csv'
try:
    r_daily = requests.get(url_daily)
    r_daily.raise_for_status()
    csv_data_daily = r_daily.text
    filename_daily = 'daily_stock_data.csv'
    filepath_daily = os.path.join(OUTPUT_DIR, filename_daily)
    with open(filepath_daily, 'w', newline='') as file:
        file.write(csv_data_daily)
    print(f"Daily stock data saved to {filepath_daily}\n")
except requests.exceptions.RequestException as e:
    print(f"Error fetching daily stock data: {e}\n")
except IOError as e:
    print(f"Error writing daily stock data to {filepath_daily}: {e}\n")


############ File 2: Company Profiles ############
print("\nFetching company profiles...\n")
url_co_profile = f'https://financialmodelingprep.com/api/v3/profile/{SYMBOLS_LIST}?apikey={API_KEY}&datatype=csv'
try:
    r_profile = requests.get(url_co_profile)
    r_profile.raise_for_status()
    csv_data_profile = r_profile.text
    filename_profiles = 'company_profiles.csv'
    filepath_profiles = os.path.join(OUTPUT_DIR, filename_profiles)
    with open(filepath_profiles, 'w', newline='') as file:
        file.write(csv_data_profile)
    print(f"Company profiles saved to {filepath_profiles}\n")
except requests.exceptions.RequestException as e:
    print(f"Error fetching company profiles: {e}\n")
except IOError as e:
    print(f"Error writing company profiles to {filepath_profiles}: {e}\n")

print("\nPython script finished.\n")
