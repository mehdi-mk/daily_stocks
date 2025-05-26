
--------- 1


SELECT
	cp.sector,
	ROUND(AVG(fmp.pe), 2) AS Average_PE,
	CAST(ROUND(AVG(fmp.marketcap), 2) AS money) AS Average_MarketCap
FROM fmp_daily_stock_data AS fmp
JOIN company_profiles AS cp
ON fmp.symbol = cp.symbol AND fmp.data_load_date = cp.data_load_date
WHERE fmp.data_load_date = (SELECT MAX(data_load_date) FROM fmp_daily_stock_data)
GROUP BY 1
ORDER BY 2 DESC;


--------- 2


WITH ranking AS (
	SELECT
		fmp.data_load_date,
		fmp.symbol,
		cp.companyName,
		fmp.changesPercentage,
		ROW_NUMBER() OVER (PARTITION BY fmp.data_load_date ORDER BY fmp.changesPercentage DESC NULLS LAST) AS rank_tops,
		ROW_NUMBER() OVER (PARTITION BY fmp.data_load_date ORDER BY fmp.changesPercentage ASC NULLS LAST) AS rank_bottoms
	FROM fmp_daily_stock_data AS fmp
	JOIN company_profiles AS cp
	ON fmp.symbol = cp.symbol AND fmp.data_load_date = cp.data_load_date
)
SELECT 
	data_load_date,
	symbol,
	companyName,
	changesPercentage,
	'Top 5' AS performers
FROM ranking
WHERE rank_tops <=5

UNION ALL

SELECT
	data_load_date,
	symbol,
	companyName,
	changesPercentage,
	'Bottom 5' AS performers
FROM ranking
WHERE rank_bottoms <= 5
ORDER BY data_load_date ASC, changesPercentage DESC;


--------- 3


WITH LatestDailyData AS (
    SELECT
        dsd.symbol,
        dsd.price,
        dsd.priceAvg50,
        dsd.priceAvg200,
        cp.sector
    FROM
        fmp_daily_stock_data dsd
    JOIN
        company_profiles cp ON dsd.symbol = cp.symbol AND dsd.data_load_date = cp.data_load_date
    WHERE
        dsd.data_load_date = (SELECT MAX(data_load_date) FROM fmp_daily_stock_data)
),
SectorCounts AS (
    SELECT
        sector,
        COUNT(*) AS total_companies_in_sector,
        SUM(CASE WHEN price > priceAvg50 AND priceAvg50 IS NOT NULL THEN 1 ELSE 0 END) AS count_above_50d_avg,
        SUM(CASE WHEN price > priceAvg200 AND priceAvg200 IS NOT NULL THEN 1 ELSE 0 END) AS count_above_200d_avg
    FROM
        LatestDailyData
    WHERE 
        price IS NOT NULL
    GROUP BY
        sector
)
SELECT
    sector,
    total_companies_in_sector,
    count_above_50d_avg,
    ROUND((count_above_50d_avg * 100.0 / total_companies_in_sector), 2) AS percentage_above_50d_avg,
    count_above_200d_avg,
    ROUND((count_above_200d_avg * 100.0 / total_companies_in_sector), 2) AS percentage_above_200d_avg
FROM
    SectorCounts
ORDER BY
    sector;
    
    
------------ Assignment:


WITH LatestData AS (
    SELECT
        dsd.symbol,
        cp.sector,
        dsd.volume,
        dsd.marketCap -- This marketCap is from the daily quote snapshot
    FROM
        fmp_daily_stock_data dsd
    JOIN
        company_profiles cp ON dsd.symbol = cp.symbol AND dsd.data_load_date = cp.data_load_date
    WHERE
        dsd.data_load_date = (SELECT MAX(data_load_date) FROM fmp_daily_stock_data) -- Corrected subquery alias
)
SELECT
    sector,
    AVG(volume) AS average_daily_volume,
    AVG(marketCap) AS average_market_cap
FROM
    LatestData
WHERE
    volume IS NOT NULL AND marketCap IS NOT NULL AND sector IS NOT NULL -- Ensure data for aggregation is clean
GROUP BY
    sector
ORDER BY
    average_market_cap DESC; -- Or order by sector, or average_daily_volume
    
    
    