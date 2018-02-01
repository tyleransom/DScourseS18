# Guide to SQL
Structured Query Language (SQL) is a commonly language for processing relational databases. Below is a beginner's guide to using SQL.

### Opening SQL
One can open SQL from the command line by typing `sqlite3` at the prompt.

### Exiting out of SQL
SQL **commands** are prepended with a "." so to exit SQL, type `.quit`

### Executing a SQL script
Supposing one has a file called `test.sql`, one can execute it by typing `.read test.sql` at the prompt (inside SQL).

### Reading data into SQL
To read data into SQL (e.g. from a CSV or tab-delimited raw file), there are actually two steps:

1. Create a SQL table which will hold the data
2. Read the raw data file into SQL's memory

To do step 1, type the following:
```python
CREATE TABLE datname(
  "var1" CHAR,
  "var2" INTEGER,
  ...
  "varN" REAL 
);
where `datname` is whatever you want to call your database in SQL.
```

To do step 2, type the following:
```python
.mode csv
.import /path/to/file.csv datname
```

It is also possible to accomplish this interactively in a GUI if you have, e.g. SQLite Studio or similar.

### Printing N observations of your database
To print N observations of your database, type
```python
SELECT * FROM datname LIMIT N;
```

To print N observations of a subset of variables, type
```python
SELECT var1, var2, ..., varK FROM datname LIMIT N;
```

### Deleting observations (and subsetting statements)
One can remove observations under certain conditions as follows:
```python
DELETE FROM datname WHERE condition; 
```
note that `condition` is some conditional statement, like `var1='value1'` or `var1=10` or `var1<=10`, etc.

If you leave off the `WHERE condition` statement, you will delete *all* observations from the database.

### Delete column from table
SQLite does not allow you to drop a column. The workaround is to make a new table that contains only the columns you want to keep, then rename the new table to the original template's name.

```python
-- Create a table called 'datname_temp' with the columns we don't want to drop
CREATE TABLE datname_temp(var1, var2, var5);

-- Copy the data from the columns we want to keep to the new table
INSERT INTO datname_temp SELECT var1, var2, var5 FROM criminals;

-- Delete the original table
DROP TABLE datname;

-- Rename the new table to the original table's name
ALTER TABLE datname_temp RENAME TO datname;
```

### Add column to table
Adding is easier than removing:
```python
ALTER TABLE datname ADD COLUMN newvarname type DEFAULT value;
```
where `newvarname` is the new column name; `type` is the type of values that column will house (e.g. text, integers, real numbers, etc.), and `value` is the default value of that column (e.g. 'one' if the type is text, '1' if the type is integer, '3.14159' if the type is real, etc.).

### Create a one-way frequency table
Create a one-way frequency table as follows:
```python
SELECT var1, COUNT(*) FROM datname GROUP BY var1;
```
This will then list the unique categories and counts for each category

### Compute summary statistics of a variable or formula of variables
```python
SELECT FUNCTION(var1) FROM datname;
```
where the following are functions:

* `AVG`: average
* `COUNT`: count
* `SUM`: sum
* `MIN`: minimum
* `MAX`: maximum

### Summary statistics of functions of variables
For example:
```python
SELECT FUNCTION(var1 + var2) FROM datname;
```python
would apply the `AVG` or `SUM` or `MIN` to the sum of `var1` and `var2`. More complex functions (like square root) are not supported in SQLite, so something like
```python
SELECT AVG(SQRT(var1)) FROM datname;
```
will not work.

But
```python
SELECT (var1-var2) AS tempvarname FROM datname;
```
will. `AS` acts as an alias.


### Saving data while using SQL
If one wants to save a database in SQL, the file extension is `.sqlite3` (but in principle you can use whatever you want). The way to save data is to issue the `.dump` command:

```python
.output datname.sqlite3
.dump
```
The result will be a text file with SQL code in it that will recreate the table you dumped.




# SQL Examples (from Chris Albon)
Taken from [Chris Albon](https://github.com/chrisalbon)'s [archived GitHub repository](https://github.com/chrisalbon/mlai) on machine learning and artifical intelligence.


## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```

## View Table


```python
-- Select everything
SELECT *

-- From the table 'criminals'
FROM criminals
```


<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>



## Delete Column


```python

-- Edit the table
ALTER TABLE criminals

-- Add a column called 'state' that contains text with the default value being 'CA'
ADD COLUMN state text DEFAULT 'CA'
```








## View Table


```python
-- Select everything
SELECT *

-- From the table 'criminals'
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
        <th>state</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
        <td>CA</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>CA</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>CA</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
        <td>CA</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
        <td>CA</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>CA</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>CA</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
        <td>CA</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'San Francisco', 0);
```








## View Table


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>



## Add New Row


```python
-- Add into the table criminals
INSERT INTO criminals 

-- A new row with these values
VALUES (512, 'Bill Byson', 21, 'M', 'Petaluma', 0);
```








## View Table Again


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Petaluma</td>
        <td>0</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## Alias Criminals Table A `C`, Then Select All Names From `C`


```python
--  Select all names from the table 'c'
SELECT c.name

-- From the criminals table, now called c
FROM criminals AS c
```




<table>
    <tr>
        <th>name</th>
    </tr>
    <tr>
        <td>James Smith</td>
    </tr>
    <tr>
        <td>Bill James</td>
    </tr>
    <tr>
        <td>Stacy Miller</td>
    </tr>
    <tr>
        <td>Betty Bob</td>
    </tr>
    <tr>
        <td>Jaden Ado</td>
    </tr>
    <tr>
        <td>Gordon Ado</td>
    </tr>
    <tr>
        <td>Bill Byson</td>
    </tr>
    <tr>
        <td>Bob Iton</td>
    </tr>
</table>




## Create Data With 'pid' As An Auto-Generated Primary Key


```python
-- Create a table of criminals with pid being a primary key integer that is auto-incremented
CREATE TABLE criminals (pid INTEGER PRIMARY KEY AUTOINCREMENT,
                        name, 
                        age, 
                        sex, 
                        city, 
                        minor);

-- Add a single row with a null value for pid
INSERT INTO criminals VALUES (NULL, 'James Smith', 15, 'M', 'Santa Rosa', 1);
```








## View Table


```python
-- Select everything
SELECT *

-- From the table 'criminals'
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>1</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
</table>



## Added More Rows With NULL Values For pid


```python
INSERT INTO criminals VALUES (NULL, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (NULL, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (NULL, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (NULL, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (NULL, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (NULL, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (NULL, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## View Table


```python
-- Select everything
SELECT *

-- From the table 'criminals'
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>1</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>2</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>3</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>4</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
    </tr>
    <tr>
        <td>5</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
    </tr>
    <tr>
        <td>6</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>7</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>8</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, NULL, 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, NULL, 23, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Petaluma', 0);
```








## Write Some SQL Code With Single And Multiline Comments


```python
--  This is a single line of commenting
SELECT name, age

FROM criminals -- It can also be placed at the end of the line

/* This is multiple 
lines of comments so we can include more
details if we need to. */
WHERE name IS NOT NULL
```




<table>
    <tr>
        <th>name</th>
        <th>age</th>
    </tr>
    <tr>
        <td>James Smith</td>
        <td>15</td>
    </tr>
    <tr>
        <td>Gordon Ado</td>
        <td>32</td>
    </tr>
    <tr>
        <td>Bill Byson</td>
        <td>21</td>
    </tr>
</table>




## Create Table


```python
-- Create a table of criminals_1
CREATE TABLE criminals_1 (pid, name, age, sex, city, minor);
INSERT INTO criminals_1 VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals_1 VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals_1 VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals_1 VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals_1 VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals_1 VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals_1 VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals_1 VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## View Table


```python
-- Select all
SELECT *

-- From the table 'criminals_1'
FROM criminals_1
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>



## Create New Empty Table


```python
-- Create a table called criminals_2
CREATE TABLE criminals_2 (pid, name, age, sex, city, minor);
```








## Copy Contents Of First Table Into Empty Table


```python
-- Insert into the empty table
INSERT INTO criminals_2

-- Everything
SELECT * 

-- From the first table
FROM criminals_1;
```








## View Previously Empty Table


```python
-- Select everything
SELECT *

-- From the previously empty table
FROM criminals_2
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>




## Create A Table


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## Select Everything In That Table


```python
-- Select everything
SELECT *

-- From the table 'criminals'
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## Create An Index Using The Column 'pid' As The Unique ID


```python
-- Create a index called uid
CREATE INDEX uid

-- For the table 'criminals' and the column 'pid'
ON criminals (pid)
```








_Note: Use 'CREATE UNIQUE INDEX' if you want the index to not contain any duplicates._


## Create New Table With Constraints On What Data Can Be Inserted


```python
-- Create a table of criminals
CREATE TABLE criminals 

(

-- With a prisoner ID (pid) that is a primary key and cannot be null
 pid    INT PRIMARY KEY     NOT NULL, 
 
-- With a name variable whose default value is John Doe
 name   TEXT                DEFAULT 'John Doe',
 
-- With an age variable that is an integer and has to be between 0 and 100
 age    INT                 CHECK(0 < age < 100)

);

```








## Add Data To Table


```python
INSERT INTO criminals VALUES (412, 'James Smith', 15);
INSERT INTO criminals VALUES (234, 'Bill James', 22);
INSERT INTO criminals VALUES (632, 'Bill Steve', 23);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL);
```








## View Table


```python
SELECT *

FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Bill Steve</td>
        <td>23</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
    </tr>
</table>




## Get Current Date


```python
-- Select the current date
SELECT date('now');
```




<table>
    <tr>
        <th>date(&#x27;now&#x27;)</th>
    </tr>
    <tr>
        <td>2017-01-19</td>
    </tr>
</table>



## Get Current Date And Time


```python
-- Select the unix time code '1200762133'
SELECT datetime('now', 'unixepoch');
```




<table>
    <tr>
        <th>datetime(&#x27;now&#x27;, &#x27;unixepoch&#x27;)</th>
    </tr>
    <tr>
        <td>1970-01-29 10:42:53</td>
    </tr>
</table>



## Compute A UNIX timestamp into a date and time


```python
-- Select the unix time code '1169229733'
SELECT datetime(1169229733, 'unixepoch');
```




<table>
    <tr>
        <th>datetime(1169229733, &#x27;unixepoch&#x27;)</th>
    </tr>
    <tr>
        <td>2007-01-19 18:02:13</td>
    </tr>
</table>



## Compute A UNIX timestamp into a date and time and convert to the local timezone.


```python
-- Select the unix time code '1171904533' and convert to the machine's local timezone
SELECT datetime(1171904533, 'unixepoch', 'localtime');
```




<table>
    <tr>
        <th>datetime(1171904533, &#x27;unixepoch&#x27;, &#x27;localtime&#x27;)</th>
    </tr>
    <tr>
        <td>2007-02-19 10:02:13</td>
    </tr>
</table>



## Compute The Day Of The Week


```python
-- Select the the day of this week (0 = Sunday, 4 = Thursday)
SELECT strftime('%w','now');
```




<table>
    <tr>
        <th>strftime(&#x27;%w&#x27;,&#x27;now&#x27;)</th>
    </tr>
    <tr>
        <td>4</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## Delete A Table


```python
-- Delete the table called 'criminals'
DROP TABLE criminals
```








## View Table


```python
-- Select everything
SELECT *

-- From the table 'criminals'
FROM criminals
```

    (sqlite3.OperationalError) no such table: criminals [SQL: "-- Select everything\nSELECT *\n\n-- From the table 'criminals'\nFROM criminals"]


_Note: We get an error because the table doesn't exist anymore._


## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## View The Table


```python
-- Select everything
SELECT *

-- From the table 'criminals'
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>



## Delete A Table


```python
-- Delete the contents of the table called 'criminals'
DELETE FROM criminals
```








## View The Table


```python
-- Select everything
SELECT *

-- From the table 'criminals'
FROM criminals
```









## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## View Table


```python
-- Select everything
SELECT *

-- From the table 'criminals'
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>



## Delete Column (Most Common)
-- Alter the table called 'criminals'
ALTER TABLE criminals

-- From the table 'criminals'
DROP COLUMN age
## Delete Column (SQLite)

SQLite (the version of SQL used in this tutorial) does not allow you to drop a column. The workaround is to make a new table that contains only the columns you want to keep, then rename the new table to the original template's name.


```python
-- Create a table called 'criminals_tamps' with the columns we want to not drop
CREATE TABLE criminals_temp(pid, name, sex);

-- Copy the data from the columns we want to keep to the new table
INSERT INTO criminals_temp SELECT pid, name, sex FROM criminals;

-- Delete the original table
DROP TABLE criminals;

-- Rename the new table to the original table's name
ALTER TABLE criminals_temp RENAME TO criminals;
```








## View Table


```python
-- Select everything
SELECT *

-- From the table 'criminals'
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>sex</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>M</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>M</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>F</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>F</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>M</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>F</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>M</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>M</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## View Table


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>



## Drop Row Based On A Conditional


```python
-- Delete all rows
DELETE FROM criminals

-- if the age is less than 18
WHERE age < 18
```








## View Table Again


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Petaluma', 0);
```








## View Table


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Petaluma</td>
        <td>0</td>
    </tr>
</table>



## Update One Row


```python
-- Update the criminals table
UPDATE criminals

-- To say city: 'Palo Alto'
SET City='Palo Alto'

-- If the prisoner ID number is 412
WHERE pid=412;
```








## Update Multiple Rows Using A Conditional


```python
-- Update the criminals table
UPDATE criminals

-- To say minor: 'No'
SET minor = 'No'

-- If age is greater than 12
WHERE age > 12;
```








## View Table Again


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Palo Alto</td>
        <td>No</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>No</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Petaluma</td>
        <td>No</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, NULL, 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, NULL, 23, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Petaluma', 0);
```








## Select Name And Ages Only When The Name Is Known


```python
--  Select name and average age,
SELECT name, age

--  from the table 'criminals',
FROM criminals

-- if age is not a null value
WHERE name IS NOT NULL
```




<table>
    <tr>
        <th>name</th>
        <th>age</th>
    </tr>
    <tr>
        <td>James Smith</td>
        <td>15</td>
    </tr>
    <tr>
        <td>Gordon Ado</td>
        <td>32</td>
    </tr>
    <tr>
        <td>Bill Byson</td>
        <td>21</td>
    </tr>
</table>




## Create Two Tables, Criminals And Crimes


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);

-- Create a table of crimes
CREATE TABLE crimes (cid, crime, city, pid_arrested, cash_stolen);
INSERT INTO crimes VALUES (1, 'fraud', 'Santa Rosa', 412, 40000);
INSERT INTO crimes VALUES (2, 'burglary', 'Petaluma', 234, 2000);
INSERT INTO crimes VALUES (3, 'burglary', 'Santa Rosa', 632, 2000);
INSERT INTO crimes VALUES (4, NULL, NULL, 621, 3500); 
INSERT INTO crimes VALUES (5, 'burglary', 'Santa Rosa', 162, 1000); 
INSERT INTO crimes VALUES (6, NULL, 'Petaluma', 901, 50000); 
INSERT INTO crimes VALUES (7, 'fraud', 'San Francisco', 412, 60000); 
INSERT INTO crimes VALUES (8, 'burglary', 'Santa Rosa', 512, 7000); 
INSERT INTO crimes VALUES (9, 'burglary', 'San Francisco', 411, 3000); 
INSERT INTO crimes VALUES (10, 'robbery', 'Santa Rosa', 632, 2500); 
INSERT INTO crimes VALUES (11, 'robbery', 'Santa Rosa', 512, 3000);
```








## Inner Join

Returns all rows whose merge-on id appears in **both** tables.


```python
-- Select everything
SELECT *

-- Left table
FROM criminals

-- Right table
INNER JOIN crimes

-- Merged on `pid` in the criminals table and `pid_arrested` in the crimes table
ON criminals.pid=crimes.pid_arrested;
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
        <th>cid</th>
        <th>crime</th>
        <th>city_1</th>
        <th>pid_arrested</th>
        <th>cash_stolen</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
        <td>1</td>
        <td>fraud</td>
        <td>Santa Rosa</td>
        <td>412</td>
        <td>40000</td>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
        <td>7</td>
        <td>fraud</td>
        <td>San Francisco</td>
        <td>412</td>
        <td>60000</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>2</td>
        <td>burglary</td>
        <td>Petaluma</td>
        <td>234</td>
        <td>2000</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>3</td>
        <td>burglary</td>
        <td>Santa Rosa</td>
        <td>632</td>
        <td>2000</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>10</td>
        <td>robbery</td>
        <td>Santa Rosa</td>
        <td>632</td>
        <td>2500</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
        <td>4</td>
        <td>None</td>
        <td>None</td>
        <td>621</td>
        <td>3500</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
        <td>5</td>
        <td>burglary</td>
        <td>Santa Rosa</td>
        <td>162</td>
        <td>1000</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>6</td>
        <td>None</td>
        <td>Petaluma</td>
        <td>901</td>
        <td>50000</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>8</td>
        <td>burglary</td>
        <td>Santa Rosa</td>
        <td>512</td>
        <td>7000</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>11</td>
        <td>robbery</td>
        <td>Santa Rosa</td>
        <td>512</td>
        <td>3000</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
        <td>9</td>
        <td>burglary</td>
        <td>San Francisco</td>
        <td>411</td>
        <td>3000</td>
    </tr>
</table>



## Left Join

Returns all rows from the left table but only the rows from the right left that match the left table.


```python
-- Select everything
SELECT *

-- Left table
FROM criminals

-- Right table
LEFT JOIN crimes

-- Merged on `pid` in the criminals table and `pid_arrested` in the crimes table
ON criminals.pid=crimes.pid_arrested;
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
        <th>cid</th>
        <th>crime</th>
        <th>city_1</th>
        <th>pid_arrested</th>
        <th>cash_stolen</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
        <td>1</td>
        <td>fraud</td>
        <td>Santa Rosa</td>
        <td>412</td>
        <td>40000</td>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
        <td>7</td>
        <td>fraud</td>
        <td>San Francisco</td>
        <td>412</td>
        <td>60000</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>2</td>
        <td>burglary</td>
        <td>Petaluma</td>
        <td>234</td>
        <td>2000</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>3</td>
        <td>burglary</td>
        <td>Santa Rosa</td>
        <td>632</td>
        <td>2000</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>10</td>
        <td>robbery</td>
        <td>Santa Rosa</td>
        <td>632</td>
        <td>2500</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
        <td>4</td>
        <td>None</td>
        <td>None</td>
        <td>621</td>
        <td>3500</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
        <td>5</td>
        <td>burglary</td>
        <td>Santa Rosa</td>
        <td>162</td>
        <td>1000</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>6</td>
        <td>None</td>
        <td>Petaluma</td>
        <td>901</td>
        <td>50000</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>8</td>
        <td>burglary</td>
        <td>Santa Rosa</td>
        <td>512</td>
        <td>7000</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
        <td>11</td>
        <td>robbery</td>
        <td>Santa Rosa</td>
        <td>512</td>
        <td>3000</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
        <td>9</td>
        <td>burglary</td>
        <td>San Francisco</td>
        <td>411</td>
        <td>3000</td>
    </tr>
</table>



_Note: FULL OUTER and RIGHT JOIN are not shown here because they are not supported by the version of SQL (SQLite) used in this tutorial._


## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Petaluma', 0);
```








## View All Rows


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Petaluma</td>
        <td>0</td>
    </tr>
</table>



## View Rows Where Age Is Greater Than 20 And City Is San Francisco


```python
--  Select all unique
SELECT distinct *

-- From the criminals table
FROM criminals

-- Where age is greater than 20 and city is San Francisco
WHERE age > 20 AND city == 'San Francisco'
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>



## View Rows Where Age Is Greater Than 20 or City Is San Francisco


```python
--  Select all unique
SELECT distinct *

-- From the criminals table
FROM criminals

-- Where age is greater than 20 and city is San Francisco
WHERE age > 20 OR city == 'San Francisco'
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Petaluma</td>
        <td>0</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## Select Based On The Result Of A Select


```python
--  Select name and age,
SELECT name, age

--  from the table 'criminals',
FROM criminals

--  where age is greater than,
WHERE age > 
     --  select age,
    (SELECT age
     --  from criminals
     FROM criminals
     --  where the name is 'James Smith'
     WHERE name == 'James Smith')
```




<table>
    <tr>
        <th>name</th>
        <th>age</th>
    </tr>
    <tr>
        <td>Bill James</td>
        <td>22</td>
    </tr>
    <tr>
        <td>Stacy Miller</td>
        <td>23</td>
    </tr>
    <tr>
        <td>Jaden Ado</td>
        <td>49</td>
    </tr>
    <tr>
        <td>Gordon Ado</td>
        <td>32</td>
    </tr>
    <tr>
        <td>Bill Byson</td>
        <td>21</td>
    </tr>
</table>


```




    'Connected: None@None'



## Create Data


```python
/* Create A Table Of Criminals */
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);

/* Create A Table Of Crimes */
CREATE TABLE crimes (cid, crime, city, pid_arrested, cash_stolen);
INSERT INTO crimes VALUES (1, 'fraud', 'Santa Rosa', 412, 40000);
INSERT INTO crimes VALUES (1, 'burglary', 'Petaluma', 234, 2000);
INSERT INTO crimes VALUES (1, 'burglary', 'Santa Rosa', 632, 2000);
INSERT INTO crimes VALUES (1, 'larcony', 'Petaluma', 621, 3500); 
INSERT INTO crimes VALUES (1, 'burglary', 'Santa Rosa', 162, 1000); 
INSERT INTO crimes VALUES (1, 'larcony', 'Petaluma', 901, 50000); 
INSERT INTO crimes VALUES (1, 'fraud', 'San Francisco', 412, 60000); 
INSERT INTO crimes VALUES (1, 'burglary', 'Santa Rosa', 512, 7000); 
INSERT INTO crimes VALUES (1, 'burglary', 'San Francisco', 411, 3000); 
INSERT INTO crimes VALUES (1, 'robbery', 'Santa Rosa', 632, 2500); 
INSERT INTO crimes VALUES (1, 'robbery', 'Santa Rosa', 512, 3000);
```

    Done.
    1 rows affected.
    1 rows affected.
    1 rows affected.
    1 rows affected.
    1 rows affected.
    1 rows affected.
    1 rows affected.
    1 rows affected.
    Done.
    1 rows affected.
    1 rows affected.
    1 rows affected.
    1 rows affected.
    1 rows affected.
    1 rows affected.
    1 rows affected.
    1 rows affected.
    1 rows affected.
    1 rows affected.
    1 rows affected.









## View Both Tables


```python
-- Select everything
SELECT *

-- From the table 'criminals'
FROM criminals
```

    Done.





<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>




```python
-- Select everything
SELECT *

-- From the table 'crimes'
FROM crimes
```

    Done.





<table>
    <tr>
        <th>cid</th>
        <th>crime</th>
        <th>city</th>
        <th>pid_arrested</th>
        <th>cash_stolen</th>
    </tr>
    <tr>
        <td>1</td>
        <td>fraud</td>
        <td>Santa Rosa</td>
        <td>412</td>
        <td>40000</td>
    </tr>
    <tr>
        <td>1</td>
        <td>burglary</td>
        <td>Petaluma</td>
        <td>234</td>
        <td>2000</td>
    </tr>
    <tr>
        <td>1</td>
        <td>burglary</td>
        <td>Santa Rosa</td>
        <td>632</td>
        <td>2000</td>
    </tr>
    <tr>
        <td>1</td>
        <td>larcony</td>
        <td>Petaluma</td>
        <td>621</td>
        <td>3500</td>
    </tr>
    <tr>
        <td>1</td>
        <td>burglary</td>
        <td>Santa Rosa</td>
        <td>162</td>
        <td>1000</td>
    </tr>
    <tr>
        <td>1</td>
        <td>larcony</td>
        <td>Petaluma</td>
        <td>901</td>
        <td>50000</td>
    </tr>
    <tr>
        <td>1</td>
        <td>fraud</td>
        <td>San Francisco</td>
        <td>412</td>
        <td>60000</td>
    </tr>
    <tr>
        <td>1</td>
        <td>burglary</td>
        <td>Santa Rosa</td>
        <td>512</td>
        <td>7000</td>
    </tr>
    <tr>
        <td>1</td>
        <td>burglary</td>
        <td>San Francisco</td>
        <td>411</td>
        <td>3000</td>
    </tr>
    <tr>
        <td>1</td>
        <td>robbery</td>
        <td>Santa Rosa</td>
        <td>632</td>
        <td>2500</td>
    </tr>
    <tr>
        <td>1</td>
        <td>robbery</td>
        <td>Santa Rosa</td>
        <td>512</td>
        <td>3000</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## View Table


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>



## Drop Row Based On A Conditional


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals

-- Only return the first two rows
LIMIT 2;
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
</table>




## Create Two Tables, Criminals And Crimes


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);

-- Create a table of crimes
CREATE TABLE crimes (cid, crime, city, pid_arrested, cash_stolen);
INSERT INTO crimes VALUES (1, 'fraud', 'Santa Rosa', 412, 40000);
INSERT INTO crimes VALUES (2, 'burglary', 'Petaluma', 234, 2000);
INSERT INTO crimes VALUES (3, 'burglary', 'Santa Rosa', 632, 2000);
INSERT INTO crimes VALUES (4, NULL, NULL, 621, 3500); 
INSERT INTO crimes VALUES (5, 'burglary', 'Santa Rosa', 162, 1000); 
INSERT INTO crimes VALUES (6, NULL, 'Petaluma', 901, 50000); 
INSERT INTO crimes VALUES (7, 'fraud', 'San Francisco', 412, 60000); 
INSERT INTO crimes VALUES (8, 'burglary', 'Santa Rosa', 512, 7000); 
INSERT INTO crimes VALUES (9, 'burglary', 'San Francisco', 411, 3000); 
INSERT INTO crimes VALUES (10, 'robbery', 'Santa Rosa', 632, 2500); 
INSERT INTO crimes VALUES (11, 'robbery', 'Santa Rosa', 512, 3000);
```








## View All Unique City Names From Both Tables


```python
-- Select city name
SELECT city 

-- From criminals table
FROM criminals

-- Then combine with
UNION

-- Select city names
SELECT city 

-- From crimes table
FROM crimes;
```




<table>
    <tr>
        <th>city</th>
    </tr>
    <tr>
        <td>None</td>
    </tr>
    <tr>
        <td>Petaluma</td>
    </tr>
    <tr>
        <td>San Francisco</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
    </tr>
</table>



## View All City Names From Both Tables


```python
-- Select city name
SELECT city 

-- From criminals table
FROM criminals

-- Then combine with
UNION ALL

-- Select city names
SELECT city 

-- From crimes table
FROM crimes;
```




<table>
    <tr>
        <th>city</th>
    </tr>
    <tr>
        <td>Santa Rosa</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
    </tr>
    <tr>
        <td>Petaluma</td>
    </tr>
    <tr>
        <td>None</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
    </tr>
    <tr>
        <td>San Francisco</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
    </tr>
    <tr>
        <td>Petaluma</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
    </tr>
    <tr>
        <td>None</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
    </tr>
    <tr>
        <td>Petaluma</td>
    </tr>
    <tr>
        <td>San Francisco</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
    </tr>
    <tr>
        <td>San Francisco</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Petaluma', 0);
```








## View All Rows

Notice that 'James Smith' appears three times


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Petaluma</td>
        <td>0</td>
    </tr>
</table>



## View Unique Rows


```python
--  Select all unique
SELECT distinct *

-- From the criminals table
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Petaluma</td>
        <td>0</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill Bayes', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Jack Killer', 23, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Petaluma', 0);
```








## View All Rows


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill Bayes</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Jack Killer</td>
        <td>23</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Petaluma</td>
        <td>0</td>
    </tr>
</table>



## View Rows Where Age Is Greater Than 30


```python
--  Select all
SELECT distinct *

-- From the criminals table
FROM criminals

-- Where age is greater than 30
WHERE age > 30
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>



## View Rows Where Age Is Greater Than Or Equal To 23


```python
--  Select all
SELECT distinct *

-- From the criminals table
FROM criminals

-- Where age is greater than 23
WHERE age >= 23
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>632</td>
        <td>Jack Killer</td>
        <td>23</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>



## View Rows Where Age Is 23


```python
--  Select all
SELECT distinct *

-- From the criminals table
FROM criminals

-- Where age is greater than 23
WHERE age = 23
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>632</td>
        <td>Jack Killer</td>
        <td>23</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>



## View Rows Where Age Is Not 23


```python
--  Select all
SELECT distinct *

-- From the criminals table
FROM criminals

-- Where age is greater than 23
WHERE age <> 23
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill Bayes</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Petaluma</td>
        <td>0</td>
    </tr>
</table>



## View Rows Where Name Begins With 'J'


```python
--  Select all
SELECT distinct *

-- From the criminals table
FROM criminals

-- Where name starts with 'J'
WHERE name LIKE 'J%'
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Jack Killer</td>
        <td>23</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>



## View Rows Where Name Contains The String 'ames'


```python
--  Select all
SELECT distinct *

-- From the criminals table
FROM criminals

-- Where name contains the string 'ames'
WHERE name LIKE '%ames%'
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## View Table


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>411</td>
        <td>Bob Iton</td>
        <td>None</td>
        <td>M</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>



## Select Rows With Names Starting With `G`


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals

-- If name starts with G
WHERE name LIKE 'G%'
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
</table>



## Select Rows With Names Ending With `o`


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals

-- If name starts ends with o
WHERE name LIKE '%o'
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>162</td>
        <td>Jaden Ado</td>
        <td>49</td>
        <td>M</td>
        <td>None</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
</table>



## Select Rows With Names Starting With Any Character, Then `ordon`


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals

-- If name starts with any character then continues with 'ordon'
WHERE name LIKE '_ordon%'
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## Select Rows That Contain An Item In A List


```python
-- Select everything
SELECT *

-- From the table 'criminals'
FROM criminals

-- Where the city is any of these cities
WHERE city IN ('Santa Rosa', 'Petaluma');
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>621</td>
        <td>Betty Bob</td>
        <td>None</td>
        <td>F</td>
        <td>Petaluma</td>
        <td>1</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## Select Every Row Where Age Is Between Two Values


```python
-- Select everything
SELECT *

-- From the table 'criminals'
FROM criminals

-- Where 
WHERE age BETWEEN 12 AND 18
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Petaluma', 0);
```








## Sort By Ascending Age And Then Alphabetically By Name


```python
--  Select all unique
SELECT distinct *

-- From the criminals table
FROM criminals

-- Sort by ascending age
ORDER BY age ASC, name
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Petaluma</td>
        <td>0</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Petaluma', 0);
```








## View All Rows


```python
--  Select all
SELECT *

-- From the criminals table
FROM criminals
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Petaluma</td>
        <td>0</td>
    </tr>
</table>



## Sort By Ascending Age


```python
--  Select all unique
SELECT distinct *

-- From the criminals table
FROM criminals

-- Sort by ascending age
ORDER BY age ASC
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Petaluma</td>
        <td>0</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>



## Sort By Descending Age


```python
--  Select all unique
SELECT distinct *

-- From the criminals table
FROM criminals

-- Sort by descending age
ORDER BY age DESC
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Petaluma</td>
        <td>0</td>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
</table>



## Sort Alphabetically


```python
--  Select all unique
SELECT distinct *

-- From the criminals table
FROM criminals

-- Sort by name
ORDER BY name
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Petaluma</td>
        <td>0</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>San Francisco</td>
        <td>0</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (621, 'Betty Bob', NULL, 'F', 'Petaluma', 1);
INSERT INTO criminals VALUES (162, 'Jaden Ado', 49, 'M', NULL, 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (411, 'Bob Iton', NULL, 'M', 'San Francisco', 0);
```








## Create A View


```python
-- Create a view called 'Santa Rosa'
CREATE VIEW [Santa Rosa] AS

-- That contains everything
SELECT *

-- From the table called 'criminals'
FROM criminals

-- If the city is 'Santa Rosa'
WHERE city = 'Santa Rosa'
```








## View The View

(I know, I know, stupid title)


```python
-- Select everything
SELECT * 

-- From the view called [Santa Rosa]
FROM [Santa Rosa]
```




<table>
    <tr>
        <th>pid</th>
        <th>name</th>
        <th>age</th>
        <th>sex</th>
        <th>city</th>
        <th>minor</th>
    </tr>
    <tr>
        <td>412</td>
        <td>James Smith</td>
        <td>15</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>1</td>
    </tr>
    <tr>
        <td>234</td>
        <td>Bill James</td>
        <td>22</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>632</td>
        <td>Stacy Miller</td>
        <td>23</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>901</td>
        <td>Gordon Ado</td>
        <td>32</td>
        <td>F</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
    <tr>
        <td>512</td>
        <td>Bill Byson</td>
        <td>21</td>
        <td>M</td>
        <td>Santa Rosa</td>
        <td>0</td>
    </tr>
</table>




## Create Data


```python
-- Create a table of criminals
CREATE TABLE criminals (pid, name, age, sex, city, minor);
INSERT INTO criminals VALUES (412, 'James Smith', 15, 'M', 'Santa Rosa', 1);
INSERT INTO criminals VALUES (234, 'Bill James', 22, 'M', 'Santa Rosa', 0);
INSERT INTO criminals VALUES (632, 'Stacy Miller', 23, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (901, 'Gordon Ado', 32, 'F', 'San Francisco', 0);
INSERT INTO criminals VALUES (512, 'Bill Byson', 21, 'M', 'Petaluma', 0);
```








## View Average Ages By City


```python
--  Select name and average age,
SELECT city, avg(age)

--  from the table 'criminals',
FROM criminals

-- after grouping by city
GROUP BY city
```




<table>
    <tr>
        <th>city</th>
        <th>avg(age)</th>
    </tr>
    <tr>
        <td>Petaluma</td>
        <td>21.0</td>
    </tr>
    <tr>
        <td>San Francisco</td>
        <td>27.5</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
        <td>18.5</td>
    </tr>
</table>



## View Max Age By City


```python
--  Select name and average age,
SELECT city, max(age)

--  from the table 'criminals',
FROM criminals

-- after grouping by city
GROUP BY city
```




<table>
    <tr>
        <th>city</th>
        <th>max(age)</th>
    </tr>
    <tr>
        <td>Petaluma</td>
        <td>21</td>
    </tr>
    <tr>
        <td>San Francisco</td>
        <td>32</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
        <td>22</td>
    </tr>
</table>



## View Count Of Criminals By City


```python
--  Select name and average age,
SELECT city, count(name)

--  from the table 'criminals',
FROM criminals

-- after grouping by city
GROUP BY city
```




<table>
    <tr>
        <th>city</th>
        <th>count(name)</th>
    </tr>
    <tr>
        <td>Petaluma</td>
        <td>1</td>
    </tr>
    <tr>
        <td>San Francisco</td>
        <td>2</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
        <td>2</td>
    </tr>
</table>



## View Total Age By City


```python
--  Select name and average age,
SELECT city, total(age)

--  from the table 'criminals',
FROM criminals

-- after grouping by city
GROUP BY city
```




<table>
    <tr>
        <th>city</th>
        <th>total(age)</th>
    </tr>
    <tr>
        <td>Petaluma</td>
        <td>21.0</td>
    </tr>
    <tr>
        <td>San Francisco</td>
        <td>55.0</td>
    </tr>
    <tr>
        <td>Santa Rosa</td>
        <td>37.0</td>
    </tr>
</table>


