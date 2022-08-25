-- vine table
CREATE TABLE vine_table (
  review_id TEXT PRIMARY KEY,
  star_rating INTEGER,
  helpful_votes INTEGER,
  total_votes INTEGER,
  vine TEXT,
  verified_purchase TEXT
);


--Import the created vine_table exported from your AWS RDS instance

--1--
--Filter the data and create a new DataFrame or table to retrieve -
--all the rows where the total_votes count is equal to or greater -
--than 20 to pick reviews that are more likely to be helpful and --
--to avoid having division by zero errors later on.----------------


SELECT *  
INTO vine_material
FROM vine_table 
WHERE total_votes >= 20
;



--2--
--Filter the new DataFrame or table created in Step 1 and create a 
--new DataFrame or table to retrieve all the rows where the number 
--of helpful_votes divided by total_votes is equal to or greater than 50%.
SELECT *
--INTO vine_moreHelpful
FROM vine_material
WHERE CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >=0.5;



--3--
--Filter the DataFrame or table created in Step 2, and create a new 
--DataFrame or table that retrieves all the rows where a review was 
--written as part of the Vine program (paid), 


SELECT *
INTO vine_paid
FROM vine_moreHelpful
WHERE vine = 'Y';



--4--
--Repeat Step 3, but this time retrieve all the rows where the review 
--was not part of the Vine program (unpaid), vine == 'N'.
SELECT *
INTO vine_unpaid
FROM vine_moreHelpful
WHERE vine = 'N';



--5--
--Determine the total number of reviews, the number of 5-star reviews, 
--and the percentage of 5-star reviews for the two types of review (paid vs unpaid).

----unpaid

SELECT
SUM(CASE WHEN star_rating = 5 THEN 1 ELSE NULL END) as fiveStar_unpaid
, SUM(CASE WHEN star_rating = 5 THEN 1 ELSE 1 END) as total_unpaid
INTO unpaid_totals
FROM vine_unpaid;

SELECT *, cast(fiveStar_unpaid as float)/cast(total_unpaid as float)*100 as fiveStar_percentage
INTO unpaid_summary
FROM unpaid_totals;




----paid

SELECT
SUM(CASE WHEN star_rating = 5 THEN 1 ELSE NULL END) as fiveStar_paid
, SUM(CASE WHEN star_rating = 5 THEN 1 ELSE 1 END) as total_paid
INTO paid_totals
FROM vine_paid;

SELECT *, cast((fiveStar_paid * 100.00 / total_paid) as float) as fiveStar_percentage
INTO paid_summary
FROM paid_totals;






SELECT * from paid_summary

SELECT * from unpaid_summary