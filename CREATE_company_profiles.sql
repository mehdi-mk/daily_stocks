CREATE TABLE IF NOT EXISTS company_profiles (
    symbol VARCHAR(20) NOT NULL,
    price NUMERIC(19, 4),
    beta NUMERIC(12, 6),
    volAvg BIGINT,
    mktCap BIGINT,
    lastDiv NUMERIC(19, 4),
    range VARCHAR(50),
    changes NUMERIC(19, 4),
    companyName VARCHAR(255),
    currency VARCHAR(10),
    cik VARCHAR(20),
    isin VARCHAR(20),
    cusip VARCHAR(20),
    exchange VARCHAR(100),
    exchangeShortName VARCHAR(50),
    industry TEXT,
    website TEXT,
    description TEXT,
    ceo VARCHAR(255),
    sector VARCHAR(100),
    country VARCHAR(10),
    fullTimeEmployees BIGINT,
    phone VARCHAR(30),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip VARCHAR(20),
    dcfDiff NUMERIC(19, 5),
    dcf NUMERIC(19, 5),
    image TEXT,
    ipoDate DATE,
    defaultImage BOOLEAN,
    isEtf BOOLEAN,
    isActivelyTrading BOOLEAN,
    isAdr BOOLEAN,
    isFund BOOLEAN,
    data_load_date DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (symbol, data_load_date)
);


COMMENT ON COLUMN company_profiles.symbol IS 'Stock ticker symbol, primary key.';
COMMENT ON COLUMN company_profiles.companyName IS 'Full name of the company.';
COMMENT ON COLUMN company_profiles.mktCap IS 'Market capitalization.';
COMMENT ON COLUMN company_profiles.industry IS 'Industry the company belongs to.';
COMMENT ON COLUMN company_profiles.sector IS 'Sector the company belongs to.';
COMMENT ON COLUMN company_profiles.ipoDate IS 'Initial Public Offering date.';
COMMENT ON COLUMN company_profiles.fullTimeEmployees IS 'Number of full-time employees.';
COMMENT ON COLUMN company_profiles.data_load_date IS 'Date when this record was last updated or inserted.';