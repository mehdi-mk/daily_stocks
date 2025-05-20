DROP TABLE fmp_daily_stock_data;

CREATE TABLE IF NOT EXISTS fmp_daily_stock_data (
    symbol VARCHAR(20) NOT NULL,
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
    open_price NUMERIC(19, 4),
    previousClose NUMERIC(19, 4),
    eps NUMERIC(12, 4),
    pe NUMERIC(12, 4),
    sharesOutstanding BIGINT,
    quote_timestamp TIMESTAMPTZ,
    data_load_date DATE NOT NULL DEFAULT CURRENT_DATE,
	PRIMARY KEY (symbol, data_load_date)
);


COMMENT ON COLUMN fmp_daily_stock_data.symbol IS 'Stock ticker symbol.';
COMMENT ON COLUMN fmp_daily_stock_data.name IS 'Company name.';
COMMENT ON COLUMN fmp_daily_stock_data.price IS 'Current trading price.';
COMMENT ON COLUMN fmp_daily_stock_data.changesPercentage IS 'Percentage change in price for the day.';
COMMENT ON COLUMN fmp_daily_stock_data.change IS 'Absolute change in price for the day.';
COMMENT ON COLUMN fmp_daily_stock_data.marketCap IS 'Total market capitalization.';
COMMENT ON COLUMN fmp_daily_stock_data.priceAvg50 IS '50-day simple moving average of price.';
COMMENT ON COLUMN fmp_daily_stock_data.priceAvg200 IS '200-day simple moving average of price.';
COMMENT ON COLUMN fmp_daily_stock_data.open_price IS 'Opening price for the day (renamed from "open" in source).';
COMMENT ON COLUMN fmp_daily_stock_data.eps IS 'Earnings Per Share.';
COMMENT ON COLUMN fmp_daily_stock_data.pe IS 'Price to Earnings ratio.';
COMMENT ON COLUMN fmp_daily_stock_data.sharesOutstanding IS 'Total number of shares outstanding.';
COMMENT ON COLUMN fmp_daily_stock_data.quote_timestamp IS 'Epoch timestamp representing when the quote data was generated/valid.';
COMMENT ON COLUMN fmp_daily_stock_data.data_load_date IS 'Date when this record was inserted into the table.';