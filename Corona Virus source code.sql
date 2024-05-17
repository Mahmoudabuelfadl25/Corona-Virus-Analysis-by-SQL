-- checking null values and replacing it with 0 if it present

SELECT *
FROM CoronaVirusDataset
WHERE province IS NULL;

SELECT *
FROM CoronaVirusDataset
WHERE Country_Region IS NULL;

SELECT *
FROM CoronaVirusDataset
WHERE latitude IS NULL;

SELECT *
FROM CoronaVirusDataset
WHERE longitude IS NULL;

SELECT *
FROM CoronaVirusDataset
WHERE confirmed IS NULL;

SELECT *
FROM CoronaVirusDataset
WHERE deaths IS NULL;

SELECT *
FROM CoronaVirusDataset
WHERE recovered IS NULL;

-- their isn't any missing or null values but if it's present I will use this code 
-- You can update NULL values in all columns of the 
-- CoronaVirusDataset table to zeros using the UPDATE statement along with the IS NULL condition. 
-- Here’s how you can do it for your specific table and columns:

UPDATE CoronaVirusDataset
SET Province = COALESCE(Province, 0),
    Latitude = COALESCE(Latitude, 0),
    Longitude = COALESCE(Longitude, 0),
    Date = COALESCE(Date, 0),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0);
    
-- To count total number of rows
SELECT COUNT(*)
FROM CoronaVirusDataset;
-- Total Number of rows is 78386

--  Geting Start date and end date 

SELECT FORMAT(MIN(CONVERT(DATE,Date,105)),'dd/mm/yyyY') as Start_date,
       FORMAT(MAX(CONVERT(DATE,Date,105)),'dd/mm/yyyY') as End_Date
FROM CoronaVirusDataset

-- Start Date is 22/1/2020 end date is 13/6/2021 

-----------------------------------------------------------


--
-- Add new column ( Month Name )
ALTER TABLE CoronaVirusDataset
ADD month_name VARCHAR(255);

-- Update new column with month names
UPDATE CoronaVirusDataset
SET month_name = 
  CASE 
    WHEN month = 1 THEN 'January'
    WHEN month = 2 THEN 'February'
    WHEN month = 3 THEN 'March'
    WHEN month = 4 THEN 'April'
    WHEN month = 5 THEN 'May'
    WHEN month = 6 THEN 'June'
    WHEN month = 7 THEN 'July'
    WHEN month = 8 THEN 'August'
    WHEN month = 9 THEN 'September'
    WHEN month = 10 THEN 'October'
    WHEN month = 11 THEN 'November'
    WHEN month = 12 THEN 'December'
    ELSE 'Invalid Month'
  END;
  
  -- checking the table with the new column month_name
  SELECT * 
  FROM CoronaVirusDataset
---------------------------------------------
--  monthly average for confirmed, deaths, recovered

SELECT 
	AVG(Confirmed) AS Avg_Confirmed,
    month_name
FROM CoronaVirusDataset
GROUP BY month_name
ORDER by  Avg_Confirmed DESC
-- December,November and January are the highest months by  average Confirmed cases
-- however February,June and July are the Lowest months by  average confirmed cases
------------------------------------------------------------------

SELECT AVG(deaths) as Avg_deaths, month_name
FROM CoronaVirusDataset
GROUP by month_name
ORDER by Avg_deaths DESC
-- December, January and April are the highest months by average deaths cases
-- but March, February and September are the lowest months by average deaths cases
--------------------------------------------
SELECT  AVG(recovered) As Avg_Recovered, month_name
FROM CoronaVirusDataset
GROUP by month_name 
ORDER by Avg_Recovered DESC
-- December, may and november are the highest months in average Recovered cases
-- February,march and july are the lowest months by average recovered cases
----------------------------------------

--  Find most frequent value for confirmed

SELECT month_name, Confirmed AS Most_Frequent_Confirmed, Frequency
FROM (
    SELECT month_name, Confirmed, COUNT(*) as Frequency,
           RANK() OVER(PARTITION BY month_name ORDER BY COUNT(*) DESC) as rank
    FROM CoronaVirusDataset
  	where confirmed not LIKE 0
    GROUP BY month_name, Confirmed
  	order by Frequency DESC
) as inner_query
WHERE rank = 1;
-- March is the month of most frequent confirmed with 383 cases distributed by 1 case every month
-- 
-------------------------------------
-- minimum values for confirmed, deaths, recovered per year

SELECT 
    year,
    MIN(Confirmed) AS Min_Confirmed,
    MIN(Deaths) AS Min_Deaths,
    MIN(Recovered) AS Min_Recovered
FROM CoronaVirusDataset
GROUP BY year
-- Their are a quite times without any confirmed, deaths or recovered cases through years

----------------------------------------------------------------
--  Maximum Values of confirmed, deaths, recovered per year
SELECT 
    year, 
    Max(Confirmed) AS Max_Confirmed, 
    Max(Deaths) AS Max_Deaths, 
    Max(Recovered) AS Max_Recovered 
FROM 
    CoronaVirusDataset 
GROUP BY 
    year
    
-- we get that in 2020 Max Confirmed cases is 9996 ,Max Deaths is 996 and max recovered is 999 case
-- and during 2021 max confirmed is 9997, max deaths is 999 and max recovered is 999 case
-------------------------------------------------------------------
-- The total number of case of confirmed, deaths, recovered each month 
SELECT month_name, 
	COUNT(confirmed) as confirmed_number,
    COUNT(deaths) as deaths_number,
    COUNT(recovered) as recovered_number
FROM CoronaVirusDataset
GROUP BY month_name
ORDER BY month_name 
-- 
------------------------------------------------------------------

-- how corona virus spread out with respect to confirmed case

SELECT province, 
       SUM(confirmed) as total_confirmed_cases, 
       AVG(confirmed) as average_confirmed_cases
FROM CoronaVirusDataset
GROUP BY province
ORDER BY SUM(confirmed) DESC

-- Corona virus spreads out strongly through US, Inia, Brazil and France 
-- And Countries with less spreading out are Australia, Greenland and Tibet
----------------------------------------------------------------------
--  Country having highest number of the Confirmed case

SELECT province , MAX(Confirmed) as max_confirmed_cases
FROM CoronaVirusDataset

-- Israel record the max number of Confirmed cases.
-------------------------------------------------------------------

--  Country having lowest number of the death case

SELECT province, MIN(deaths) as min_death_cases
FROM CoronaVirusDataset;

-- Afghanistan record no deaths by corona. 
------------------------------------------------------------------
-- top 5 countries having highest recovered case
SELECT province, SUM(recovered) as total_recovered_cases
FROM CoronaVirusDataset
GROUP BY province
ORDER BY total_recovered_cases DESC
-- India, Brazil, USA, Turkey and Russia are the highest countries that have recovry cases


