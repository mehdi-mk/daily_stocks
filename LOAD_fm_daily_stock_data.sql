CREATE TEMP TABLE fmp_daily_staging (
    symbol VARCHAR(20),
    name VARCHAR(255),
    price NUMERIC(19, 4),
    changesPercentage NUMERIC(10, 4),
    change NUMERIC(19, 4),
    dayLow NUMERIC(19, 4),
    dayHigh NUMERIC(19, 4),
    yearHigh NUMERIC(19, 4),
    yearLow NUMERIC(19, 4),
    marketCap BIGINT,
    priceAvg50 NUMERIC(19, 4),
    priceAvg200 NUMERIC(19, 4),
    exchange VARCHAR(50),
    volume BIGINT,
    avgVolume NUMERIC(20, 4),
    "open" NUMERIC(19, 4),
    previousClose NUMERIC(19, 4),
    eps NUMERIC(12, 4),
    pe NUMERIC(12, 4),
    sharesOutstanding BIGINT,
    "timestamp" BIGINT
);

COPY fmp_daily_staging (
    symbol, name, price, changesPercentage, change, dayLow, dayHigh, yearHigh, yearLow,
    marketCap, priceAvg50, priceAvg200, exchange, volume, avgVolume, "open",
    previousClose, eps, pe, sharesOutstanding, "timestamp"
)
-- IMPORTANT NOTE: SET YOUR CSV FILE PATH HERE
FROM '/tmp/daily_stock_data.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

INSERT INTO fmp_daily_stock_data (
    symbol, name, price, changesPercentage, change, dayLow, dayHigh, yearHigh, yearLow,
    marketCap, priceAvg50, priceAvg200, exchange, volume, avgVolume, open_price,
    previousClose, eps, pe, sharesOutstanding, quote_timestamp, data_load_date
)
SELECT
    s.symbol,
    s.name,
    s.price,
    s.changesPercentage,
    s.change,
    s.dayLow,
    s.dayHigh,
    s.yearHigh,
    s.yearLow,
    s.marketCap,
    s.priceAvg50,
    s.priceAvg200,
    s.exchange,
    s.volume,
    s.avgVolume,
    s."open",
    s.previousClose,
    s.eps,
    s.pe,
    s.sharesOutstanding,
    to_timestamp(s."timestamp"),
    CURRENT_DATE
FROM fmp_daily_staging s
ON CONFLICT (symbol, data_load_date) DO UPDATE SET
    name = EXCLUDED.name,
    price = EXCLUDED.price,
    changesPercentage = EXCLUDED.changesPercentage,
    change = EXCLUDED.change,
    dayLow = EXCLUDED.dayLow,
    dayHigh = EXCLUDED.dayHigh,
    yearHigh = EXCLUDED.yearHigh,
    yearLow = EXCLUDED.yearLow,
    marketCap = EXCLUDED.marketCap,
    priceAvg50 = EXCLUDED.priceAvg50,
    priceAvg200 = EXCLUDED.priceAvg200,
    exchange = EXCLUDED.exchange,
    volume = EXCLUDED.volume,
    avgVolume = EXCLUDED.avgVolume,
    open_price = EXCLUDED.open_price,
    previousClose = EXCLUDED.previousClose,
    eps = EXCLUDED.eps,
    pe = EXCLUDED.pe,
    sharesOutstanding = EXCLUDED.sharesOutstanding,
    quote_timestamp = EXCLUDED.quote_timestamp;

DROP TABLE fmp_daily_staging;