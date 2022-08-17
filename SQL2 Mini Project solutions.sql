-- 1.	Import the csv file to a table in the database.
CREATE DATABASE mini_pro;
use mini_pro;
select * from icc_data;


-- 2.	Remove the column 'Player Profile' from the table.
set sql_safe_updates= 0;
alter table icc_data drop column `player Profile`;  

-- 3.	Extract the country name and player names from the given data and store it in seperate columns for further usage.
# for country
ALTER TABLE icc_data ADD COLUMN `country` VARCHAR(20);
UPDATE icc_data
SET country = TRIM(')' FROM substr(Player,instr(Player,'(')+1));

# For player name 
ALTER TABLE icc_data ADD COLUMN `player_name` VARCHAR(20);
UPDATE icc_data
SET player_name = SUBSTR(Player,1, instr(Player,'(')-2);

select * from icc_data;

-- 4.	From the column 'Span' extract the start_year and end_year and store them in seperate columns for further usage.
 select SUBSTR(Span,1, instr(Span,'-')-1) from icc_data;
ALTER TABLE icc_data ADD COLUMN `start_year` VARCHAR(20);
UPDATE icc_data
SET start_year = SUBSTR(Span,1, instr(Span,'-')-1);


ALTER TABLE icc_data ADD COLUMN `end_year` VARCHAR(20);
UPDATE icc_data
SET end_year = TRIM('-' from SUBSTR(span, instr(span,'-')+1));

-- 5.	The column 'HS' has the highest score scored by the player so far in any given match. 
-- The column also has details if the player had completed the match in a NOT OUT status. 
-- Extract the data and store the highest runs and the NOT OUT status in different columns.

alter table icc_data add column highscore int(10);
UPDATE icc_data
SET highscore = (TRIM('*' from hs)); 

ALTER TABLE icc_data ADD COLUMN not_out varchar(20);
UPDATE icc_data 
SET not_out = substr(hs, instr(hs, '*'));

select * from icc_data;

-- 6.	Using the data given, considering the players who were active in the year of 2019,
--  create a set of batting order of best 6 players using 
-- the selection criteria of those who have a good average score across all matches for India.

select player, runs, Avg from icc_data
WHERE ((end_year <= 2019) AND (start_year <= 2019)) AND country LIKE '%INDIA%'
order by AVG DESC 
LIMIT 6;


-- 7.	Using the data given, considering the players who were active in the year of 2019,
--  create a set of batting order of best 6 players using the selection criteria
--  of those who have highest number of 100s across all matches for India.

select player, runs, `100` from icc_data 
WHERE ((end_year>= 2019) AND (start_year <= 2019)) AND country LIKE '%INDIA%'
ORDER BY `100` DESC
LIMIT 6;


-- 8.	Using the data given, considering the players who were active in the year of 2019,
--  create a set of batting order of best 6 players using 2 selection criterias of your own for India.

# criteria (HS & 100)

select player, HS, `100` from icc_data
WHERE ((end_year>= 2019) AND (start_year <= 2019)) AND country LIKE '%INDIA%'
ORDER BY `100` DESC, HS DESC 
LIMIT 6; 


# Other criteria (AVG & 100)

select player, AVG, `100` from icc_data
WHERE ((end_year>= 2019) AND (start_year <= 2019)) AND country LIKE '%INDIA%'
ORDER BY AVG DESC, `100` DESC
LIMIT 6; 

-- 9.	Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given,
--  considering the players who were active in the year of 2019, 
-- create a set of batting order of best 6 players using the selection criteria of those
--  who have a good average score across all matches for South Africa.

CREATE VIEW Batting_Order_GoodAvgScorers_SA AS
select player , avg  from icc_data
WHERE ((end_year>= 2019) AND (start_year <= 2019)) AND country LIKE '%SA%'
ORDER BY avg DESC
LIMIT 6;

select * from Batting_Order_GoodAvgScorers_SA;

-- 10.	Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given,
--  considering the players who were active in the year of 2019, 
-- create a set of batting order of best 6 players using the selection criteria 
-- of those who have highest number of 100s across all matches for South Africa.

CREATE VIEW Batting_Order_HighestCenturyScorers_SA AS
select player , `100`  from icc_data
WHERE ((end_year>= 2019) AND (start_year <= 2019)) AND country LIKE '%SA%'
ORDER BY `100` DESC
LIMIT 6;

select * from Batting_Order_HighestCenturyScorers_SA;