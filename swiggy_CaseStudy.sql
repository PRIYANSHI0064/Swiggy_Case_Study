show databases;
use sql_project_swiggy;

SELECT * FROM  swiggy;

-- 01 HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?

SELECT COUNT(distinct restaurant_name) AS High_rated_restaurant
FROM swiggy
WHERE rating > 4.5;


SELECT DISTINCT restaurant_name as High_rated_restaurant, rating
FROM swiggy
WHERE rating > 4.5
ORDER BY rating DESC;

/* Bombay Kulfis, Chaska Bun, Havmor Havfunn ice cream, Makers of Milkshakes and Natural Ice Cream
aew top 5 high_rates restaurants having 4.7 rating among  all*/

-- 02 HOW MANY RESTAURANTS SELL( HAVE WORD "PIZZA" IN THEIR NAME)?

SELECT COUNT(distinct restaurant_name) AS restaurant_count
FROM swiggy 
WHERE restaurant_name like '%Pizza%';

SELECT DISTINCT restaurant_name 
FROM swiggy 
WHERE restaurant_name LIKE '%Pizza%';

/* There are 4 restaurant , having word Pizza in their name */


-- 03 WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?

SELECT cuisine , count(*) AS cuisine_count
FROM Swiggy
GROUP BY cuisine
ORDER BY cuisine_count DESC
LIMIT 1 ;

/* 'North Indian,Chinese' cuisine is most popular and common among all the restaurants */


-- 05 WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?

SELECT city , ROUND(AVG(rating),2) AS avg_rating
FROM swiggy
GROUP BY city;


-- 06 WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?

SELECT DISTINCT restaurant_name, menu_category,
MAX(price) AS Highest_price
FROM Swiggy
WHERE menu_category = 'Recommended'
GROUP BY  restaurant_name, menu_category;


-- 07 FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE. 

SELECT DISTINCT restaurant_name , cost_per_person
FROM Swiggy
WHERE cuisine <> 'Indian'
ORDER BY cost_per_person DESC
LIMIT 5;

-- 08 FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL RESTAURANTS TOGETHER.

SELECT DISTINCT restaurant_name , cost_per_person
FROM Swiggy
WHERE cost_per_person > ( SELECT AVG(cost_per_person)
                         FROM Swiggy);

-- 09 RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.

SELECT DISTINCT S1.restaurant_name , S1.city, S2.city
FROM Swiggy S1 
JOIN Swiggy S2
ON S1.restaurant_name = S2.restaurant_name and
S1.city <> S2.city;


-- 10 WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?

SELECT DISTINCT restaurant_name, menu_category, 
COUNT(item) as Total_items
FROM Swiggy
WHERE menu_category = 'main course'
GROUP BY restaurant_name, menu_category
ORDER BY Total_items DESC LIMIT 1 ; 

/* 'Spice Up' is the restaurant  where most number of items offers in the "Main Course" Category */



-- 11 LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME

SELECT * FROM  Swiggy;

SELECT DISTINCT restaurant_name ,
(COUNT(CASE WHEN veg_or_nonveg = 'veg' THEN 1 END)* 100
/ COUNT(*)) AS Vegetarian_percentage
FROM Swiggy 
GROUP BY restaurant_name
HAVING Vegetarian_percentage = 100.00
ORDER BY restaurant_name;


-- 12 WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?

SELECT DISTINCT restaurant_name , AVG(price) AS avg_price
FROM Swiggy
GROUP BY restaurant_name 
ORDER BY avg_price  LIMIT 1;


-- 13 WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?

SELECT DISTINCT restaurant_name , COUNT(DISTINCT menu_category) AS Menu_Count
FROM Swiggy
GROUP BY restaurant_name 
ORDER BY Menu_Count DESC
LIMIT 5;



-- 14 WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?

SELECT * FROM  Swiggy;

SELECT DISTINCT restaurant_name ,
(COUNT(CASE WHEN veg_or_nonveg = 'Non-veg' THEN 1 END)* 100
/ COUNT(*)) AS Non_Vegetarian_percentage
FROM Swiggy 
GROUP BY restaurant_name
ORDER BY Non_Vegetarian_percentage DESC;



-- 15 Determine the Most Expensive and Least Expensive Cities for Dining:

SELECT * FROM  Swiggy;  


WITH CityExpense AS (
SELECT city, MAX(cost_per_person) AS MAX_Cost,
MIN(cost_per_person) AS MIN_Cost 
FROM Swiggy
GROUP BY city
)
SELECT city , MAX_Cost, MIN_Cost 
FROM CityExpense
ORDER BY MAX_Cost DESC;



-- 16 Calculate the Rating Rank for Each Restaurant Within Its City


WITH RatingRankByCity as(
SELECT DISTINCT restaurant_name, city, rating,
DENSE_RANK() OVER (PARTITION BY city ORDER BY rating DESC) AS Rating_Rank
FROM Swiggy 
)
SELECT * From RatingRankByCity
WHERE Rating_Rank = 1;

