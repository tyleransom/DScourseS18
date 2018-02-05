CREATE TABLE "FL_insurance_sample" (
	"policyID" INTEGER,
	"statecode" CHAR,
	"county" CHAR,
	"eq_site_limit" REAL,
	"hu_site_limit" REAL,
	"fl_site_limit" REAL,
	"fr_site_limit" REAL,
	"tiv_2011" REAL,
	"tiv_2012" REAL,
	"eq_site_deductible" REAL,
	"hu_site_deductible" REAL,
	"fl_site_deductible" REAL,
	"fr_site_deductible" REAL,
	"point_latitude" REAL,
	"point_longitude" REAL,
	"line" CHAR,
	"construction" CHAR,
	"point_granularity" INTEGER
);

.mode csv
.import FL_insurance_sample.csv FL_insurance_sample

SELECT * FROM FL_insurance_sample LIMIT 10;
SELECT county, COUNT(*) FROM FL_insurance_sample GROUP BY county;
SELECT (tiv_2012-tiv_2011) AS diff FROM FL_insurance_sample;
ALTER TABLE FL_insurance_sample ADD COLUMN diff integer DEFAULT 0;
SELECT AVG(diff) FROM FL_insurance_sample;
SELECT construction, COUNT(*) FROM FL_insurance_sample GROUP BY construction;

