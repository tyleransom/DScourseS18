-- ******************
-- Import data
-- ******************
-- Season,Daynum,Wteam,Wscore,Lteam,Lscore,Wloc,Numot
-- 1985,20,1228,81,1328,64,N,0
.print ' '
.print 'Importing data'
-- First, create the table that the CSV will be stored in
CREATE TABLE "basketball" (
	Season INTEGER,
	Daynum INTEGER,
	WteamID INTEGER,
	Wscore INTEGER,
	LteamID INTEGER,
	Lscore INTEGER,
	Wloc CHAR(1),
	NumOT INTEGER
);

-- Tell SQL to expect a CSV file by declaring CSV mode
.mode csv

-- Next, import the CSV following the directions on the sqlitetutorial website
.import basketball.csv basketball

-- Drop the header row
DELETE FROM basketball WHERE Season = 'Season';




-- ******************
-- View first 10 observations
-- ******************
.print ' '
.print 'View first 10 observations'
-- View first 10 observations
SELECT * FROM basketball LIMIT 10;

-- View first 10 observations of only a set of variables (Season, Wscore, Lscore, Wloc)
SELECT Season, Wscore, Lscore, Wloc FROM basketball LIMIT 10;




-- ******************
-- How many unique values of a certain variable?
-- ******************
.print ' '
.print 'Unique values'
-- Number of unique counties in the data (lists a number)
SELECT count(distinct Season) from basketball;
-- or lists each one in a separate line
SELECT DISTINCT Season FROM basketball;
-- or lists each one in a separate line with counts 
SELECT Season, COUNT(*) FROM basketball GROUP BY Season;




-- ******************
-- Average margin of victory?
-- ******************
.print ' '
.print 'Margin of victory'
-- Create new column which is the Wscore-Lscore difference, then find the average of it
SELECT AVG(Wscore) FROM basketball;
SELECT AVG(Lscore) FROM basketball;
SELECT  AVG(Wscore-LScore) FROM basketball;


-- ******************
-- Distribution of categories
-- ******************
.print ' '
.print 'Categorical distribution'
-- Frequency table of NumOT
SELECT NumOT, COUNT(*) FROM basketball GROUP BY NumOT;


-- ******************
-- Save as text file
-- ******************
.output basketball.sqlite3
.dump


-- ProTip: You can execute this file from the Linux command line by issuing the following:
-- sqlite3 < SQLexample.sql > SQLexample.sqlog
