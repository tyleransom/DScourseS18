-- First, create the table that the CSV will be stored in
CREATE TABLE "Insurance" (
	policyID INTEGER,
	statecode TEXT,
	county TEXT,
	eq_site_limit REAL,
	hu_site_limit REAL,
	fl_site_limit REAL,
	fr_site_limit REAL,
	tiv_2011 REAL,
	tiv_2012 REAL,
	eq_site_deductible REAL,
	hu_site_deductible REAL,
	fl_site_deductible REAL,
	fr_site_deductible REAL,
	point_latitude REAL,
	point_longitude REAL,
	line TEXT,
	construction TEXT,
	point_granularity INTEGER
);

-- Tell SQL to expect a CSV file by declaring CSV mode
.mode csv

-- Next, import the CSV following the directions on the sqlitetutorial website
.import FL_insurance_sample.csv Insurance

-- Drop the header row
DELETE FROM Insurance WHERE county = 'county';

-- View first 10 observations
SELECT * FROM Insurance LIMIT 10;

-- View first 10 observations of policyID, county, and tiv_2011-2012
SELECT policyID, county, tiv_2011, tiv_2012 FROM Insurance LIMIT 10;

-- Number of unique counties in the data (lists a number)
SELECT count(distinct county) from Insurance;
-- or lists each one in a separate line
SELECT DISTINCT county FROM Insurance;
-- or lists each one in a separate line with counts 
SELECT county, COUNT(*) FROM Insurance GROUP BY county;


