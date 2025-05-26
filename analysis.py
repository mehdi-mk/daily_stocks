########## Question 1 ##########

import pandas as pd

# --- Configuration ---
daily_data_csv_path = 'path/to/your/daily_stock_data.csv' # <-- UPDATE THIS PATH
profiles_csv_path = 'path/to/your/company_profiles.csv' # <-- UPDATE THIS PATH

# df_quotes = pd.read_csv(daily_data_csv_path, parse_dates=['data_load_date'])
# df_profiles = pd.read_csv(profiles_csv_path, parse_dates=['data_load_date'])

# --- Data Preprocessing ---
df_quotes['data_load_date'] = pd.to_datetime(df_quotes['data_load_date']).dt.date
df_profiles['data_load_date'] = pd.to_datetime(df_profiles['data_load_date']).dt.date

df_quotes_selected = df_quotes[['symbol', 'data_load_date', 'pe', 'marketCap']].copy()
df_quotes_selected['pe'] = pd.to_numeric(df_quotes_selected['pe'], errors='coerce')
df_quotes_selected['marketCap'] = pd.to_numeric(df_quotes_selected['marketCap'], errors='coerce')

df_profiles_selected = df_profiles[['symbol', 'data_load_date', 'sector', 'companyName']].copy()

# --- Analysis for the Most Recent Day ---
most_recent_date = df_quotes_selected['data_load_date'].max()

df_quotes_latest = df_quotes_selected[df_quotes_selected['data_load_date'] == most_recent_date]
df_profiles_latest = df_profiles_selected[df_profiles_selected['data_load_date'] == most_recent_date]

df_merged_latest = pd.merge(df_quotes_latest, df_profiles_latest, on=['symbol', 'data_load_date'], how='inner')

df_analysis = df_merged_latest.dropna(subset=['pe', 'marketCap', 'sector'])

sector_valuation_comparison = df_analysis.groupby('sector').agg(
average_pe_ratio=('pe', 'mean'),
average_market_cap=('marketCap', 'mean'),
company_count=('symbol', 'count')


########## Question 2 ##########


import pandas as pd

# --- Configuration ---
daily_data_csv_path = 'path/to/your/daily_stock_data.csv' # <-- UPDATE THIS PATH
profiles_csv_path = 'path/to/your/company_profiles.csv' # <-- UPDATE THIS PATH
N_PERFORMERS = 5

# --- Load Data ---
try:
    df_quotes = pd.read_csv(daily_data_csv_path, parse_dates=['data_load_date'])
    df_profiles = pd.read_csv(profiles_csv_path, parse_dates=['data_load_date'])
except FileNotFoundError:
    print(f"Error: One or both CSV files not found. Please check paths.")
    # exit()
except KeyError as e:
    print(f"Error: Missing 'data_load_date' column in one of the CSVs as expected: {e}")
    # exit()

print("--- Data Loaded ---")

# --- Data Preprocessing ---
df_quotes['data_load_date'] = pd.to_datetime(df_quotes['data_load_date']).dt.date
df_profiles['data_load_date'] = pd.to_datetime(df_profiles['data_load_date']).dt.date

# Prepare quotes data
df_quotes_perf = df_quotes[['symbol', 'data_load_date', 'changesPercentage']].copy()
df_quotes_perf['changesPercentage'] = pd.to_numeric(df_quotes_perf['changesPercentage'], errors='coerce')
df_quotes_perf.dropna(subset=['changesPercentage', 'data_load_date'], inplace=True)

# Prepare profiles data for merging companyName
df_profiles_names = df_profiles[['symbol', 'data_load_date', 'companyName']].copy()

# Merge quotes and profiles on both symbol and data_load_date
df_merged = pd.merge(df_quotes_perf, df_profiles_names, on=['symbol', 'data_load_date'], how='left')
# If companyName might be missing for some profile dates, you might want to fill it with the latest known name:
# df_profiles_latest_names = df_profiles.sort_values('data_load_date').drop_duplicates(subset=['symbol'], keep='last')[['symbol', 'companyName']]
# df_merged = pd.merge(df_quotes_perf, df_profiles_latest_names, on='symbol', how='left')


print(f"\n--- Data for Performance Analysis (shape: {df_merged.shape}) ---")

# --- Analysis: Top and Bottom N Performers for each available day ---
if not df_merged.empty and 'data_load_date' in df_merged.columns:
    daily_results_list = [] # To store dataframes for later consistency check
    
    # Ensure there are unique dates to iterate over
    unique_dates = df_merged['data_load_date'].unique()
    if pd.Series(unique_dates).notna().all() and len(unique_dates) > 0 :
        for specific_date in sorted(unique_dates): # Iterate in chronological order
            print(f"\n--- Performance Analysis for Date: {specific_date} ---")
            
            group = df_merged[df_merged['data_load_date'] == specific_date]
            
            if not group.empty:
                top_performers = group.nlargest(N_PERFORMERS, 'changesPercentage')
                bottom_performers = group.nsmallest(N_PERFORMERS, 'changesPercentage')

                print(f"\nTop {N_PERFORMERS} Performers on {specific_date}:")
                print(top_performers[['symbol', 'companyName', 'changesPercentage']])
                daily_results_list.append(top_performers.assign(performance_type='Top'))
                
                print(f"\nBottom {N_PERFORMERS} Performers on {specific_date}:")
                print(bottom_performers[['symbol', 'companyName', 'changesPercentage']])
                daily_results_list.append(bottom_performers.assign(performance_type='Bottom'))
            else:
                print(f"No data for {specific_date} after processing.")
        
        # Optional: Analyze consistency
        if daily_results_list:
            all_ranked_df = pd.concat(daily_results_list)
            print("\n--- Consistency Check (Number of times a symbol appeared in Top/Bottom lists) ---")
            # Ensure companyName is present; if not, it might affect groupby
            all_ranked_df['companyName'] = all_ranked_df['companyName'].fillna('N/A') 
            consistency_count = all_ranked_df.groupby(['symbol', 'companyName', 'performance_type']).size().reset_index(name='appearance_count')
            print(consistency_count[consistency_count['appearance_count'] > 1].sort_values(by=['appearance_count', 'symbol', 'performance_type'], ascending=[False, True, True]))
    else:
        print("\nNo valid dates found to process in 'data_load_date' column.")
else:
    print("\nNo performance data available after cleaning or 'data_load_date' is missing.")
    

########## Question 3 ##########


import pandas as pd

# --- Configuration ---
daily_data_csv_path = 'path/to/your/daily_stock_data.csv' # <-- UPDATE THIS PATH
profiles_csv_path = 'path/to/your/company_profiles.csv' # <-- UPDATE THIS PATH

# --- Load Data ---
try:
    df_quotes = pd.read_csv(daily_data_csv_path, parse_dates=['data_load_date'])
    df_profiles = pd.read_csv(profiles_csv_path, parse_dates=['data_load_date'])
except FileNotFoundError:
    print(f"Error: One or both CSV files not found. Please check paths.")
    # exit()
except KeyError as e:
    print(f"Error: Missing 'data_load_date' column in one of the CSVs as expected: {e}")
    # exit()

print("--- Data Loaded ---")

# --- Data Preprocessing ---
df_quotes['data_load_date'] = pd.to_datetime(df_quotes['data_load_date']).dt.date
df_profiles['data_load_date'] = pd.to_datetime(df_profiles['data_load_date']).dt.date

df_quotes_selected = df_quotes[['symbol', 'data_load_date', 'price', 'priceAvg50', 'priceAvg200']].copy()
numeric_cols = ['price', 'priceAvg50', 'priceAvg200']
for col in numeric_cols:
    df_quotes_selected[col] = pd.to_numeric(df_quotes_selected[col], errors='coerce')

df_profiles_selected = df_profiles[['symbol', 'data_load_date', 'sector']].copy()

# --- Analysis for the Most Recent Day ---
if not df_quotes_selected.empty and df_quotes_selected['data_load_date'].notna().any():
    most_recent_date = df_quotes_selected['data_load_date'].max()
    print(f"\nAnalyzing data for the most recent data_load_date: {most_recent_date}")

    df_quotes_latest = df_quotes_selected[df_quotes_selected['data_load_date'] == most_recent_date]
    df_profiles_latest = df_profiles_selected[df_profiles_selected['data_load_date'] == most_recent_date]
    
    df_merged_latest = pd.merge(df_quotes_latest, df_profiles_latest, 
                                on=['symbol', 'data_load_date'], how='inner')

    df_analysis = df_merged_latest.dropna(subset=['price', 'priceAvg50', 'priceAvg200', 'sector'])

    if not df_analysis.empty:
        df_analysis['above_50d_avg'] = (df_analysis['price'] > df_analysis['priceAvg50'])
        df_analysis['above_200d_avg'] = (df_analysis['price'] > df_analysis['priceAvg200'])

        sector_sentiment = df_analysis.groupby('sector').agg(
            total_companies=('symbol', 'count'),
            count_above_50d=('above_50d_avg', 'sum'), 
            count_above_200d=('above_200d_avg', 'sum')  
        ).reset_index()

        sector_sentiment['percentage_above_50d_avg'] = \
            (sector_sentiment['count_above_50d'] / sector_sentiment['total_companies'] * 100).round(2)
        sector_sentiment['percentage_above_200d_avg'] = \
            (sector_sentiment['count_above_200d'] / sector_sentiment['total_companies'] * 100).round(2)

        print("\n--- Stock Prices Relative to Moving Averages by Sector (Most Recent Day) ---")
        print(sector_sentiment[['sector', 'total_companies', 'percentage_above_50d_avg', 'percentage_above_200d_avg']])
    else:
        print("\nNot enough data for sentiment analysis on the most recent day after cleaning.")
else:
    print("\n'data_load_date' column not found, empty, or no data after initial load in quotes data. Cannot determine the most recent day.")