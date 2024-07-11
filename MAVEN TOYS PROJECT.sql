CREATE TABLE sales(
	sale_id SERIAL PRIMARY KEY,
	date TIMESTAMP NOT NULL,
	store_id INT NOT NULL,
	product_id INT NOT NULL,
	units INT NOT NULL
);

CREATE TABLE inventory(
	store_id INT NOT NULL,
	product_id INT NOT NULL,
	stock_on_hand INT NOT NULL
);

CREATE TABLE product(
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR (50) NOT NULL,
	poduct_category VARCHAR (50) NOT NULL,
	product_cost INT NOT NULL,
	product_price INT NOT NULL
);


CREATE TABLE stores(
	store_id SERIAL PRIMARY KEY,
	store_name VARCHAR (50) NOT NULL,
	store_city VARCHAR (50) NOT NULL,
	store_location VARCHAR (50) NOT NULL,
	store_open_date TIMESTAMP NOT NULL
);

SELECT * FROM inventory;
SELECT * FROM product;

ALTER TABLE product 
	ALTER COLUMN product_cost TYPE MONEY,
	ALTER COLUMN product_price TYPE MONEY;

SELECT * FROM sales;
SELECT * FROM stores;
	
ALTER TABLE stores
	ALTER COLUMN store_open_date TYPE DATE;
	
SELECT * FROM stores;
SELECT * FROM sales;
SELECT * FROM product;

ALTER TABLE sales
	ALTER COLUMN date TYPE DATE;



-------------------------------------------
SELECT
    p.product_category,
    st.store_location,
    SUM((p.product_price - p.product_cost) * s.units) AS total_profit
FROM
    sales AS s
JOIN
    product p ON s.product_id = p.product_id
JOIN
    stores AS st ON s.store_id = st.store_id
WHERE p.product_category = 'Toys' 
GROUP BY
    p.product_category, st.store_location
ORDER BY
    p.product_category, total_profit DESC;


--QUESTION 1. WHICH PRODUCT CATEGORIES DRIVE THE BIGGEST PROFITS?

CREATE VIEW total_profit AS (
	SELECT
	p.product_category,
 	p.product_cost,
	p.product_price,
	sa.units,
	st.store_location,
	(p.product_price - p.product_cost) * sa.units AS profit
FROM
	product AS p
JOIN
	sales AS sa
ON sa.product_id = p.product_id
JOIN
	stores AS st
ON st.store_id = sa.store_id
ORDER BY profit DESC
);

SELECT 
	product_category,
	SUM (profit) AS product_profit
FROM total_profit
GROUP BY product_category
ORDER BY product_profit DESC
	LIMIT 1
	
-- THE PRODUCT CATEGORY WITH THE HIGHEST PROFIT IS "TOYS"

------------------------------------------------------------------
---- QUESTION 1B. IS THIS SAME ACROSS ALL STORE LOCATION SELECT

SELECT
    p.product_category,
    st.store_location,
    SUM((p.product_price - p.product_cost) * s.units) AS total_profit
FROM
    sales AS s
JOIN
    product p ON s.product_id = p.product_id
JOIN
    stores AS st ON s.store_id = st.store_id
GROUP BY
    p.product_category, st.store_location
ORDER BY
    p.product_category, total_profit DESC;

-----------

-- AT AIRPORT
SELECT 
	product_category,
	SUM (profit) AS product_profit
FROM total_profit
WHERE store_location = 'Airport'
GROUP BY 1
ORDER BY product_profit DESC;

--THE HIGHEST PROFIT IN LOCATION 'AIRPORT' IS DRIVEN BY THE PRODUCT 'ELECTRONICS'

-- AT Commercial

SELECT 
	product_category,
	SUM (profit) AS product_profit
FROM total_profit
WHERE store_location = 'Commercial'
GROUP BY product_category
ORDER BY product_profit DESC;
--THE HIGHEST PROFIT IN LOCATION 'COMMERCIAL' IS DRIVEN BY THE PRODUCT 'ELECTRONICS'


-- AT Downtown

SELECT 
	product_category,
	SUM (profit) AS product_profit
FROM total_profit
WHERE store_location = 'Downtown'
GROUP BY product_category
ORDER BY product_profit DESC;
--THE HIGHEST PROFIT IN LOCATION 'DOWNTOWN' IS DRIVEN BY THE PRODUCT 'TOYS'



-- AT Residential

SELECT 
	product_category,
	SUM (profit) AS product_profit
FROM total_profit
WHERE store_location = 'Residential'
GROUP BY product_category
ORDER BY product_profit DESC;
--THE HIGHEST PROFIT IN LOCATION 'Residential' IS DRIVEN BY THE PRODUCT 'TOYS'

-- THEREFOR, THE HIGHEST PROFIT DRIVEN PRODUCT ARE NOT SAME ACROSS ALL STORE LOCATION


--QUESTION 2A. HOW MUCH MONEY IS TIED UP IN INVENTORY AT THE TOYS STORE?
SELECT * FROM inventory;
SELECT * FROM sales;
SELECT * FROM stores;
SELECT * FROM product;

--AMOUNT TIED UP IN THE INVENTORY AT THE TOY STORES
SELECT 
SUM (i.stock_on_hand) AS total_stock_in_unit,
SUM (i.stock_on_hand * p.product_cost) AS stock_on_hand_cost
FROM product AS p
JOIN
	inventory AS i
ON i.product_id = p.product_id

--THE TOTAL MONEY TIED DOWN IN THE INVENTORY IS $300,209.58


--QUESTION 2B. HOW LONG WILL IT TAKE THE NUMBER OF STOCK ON HAND TO BE SOLD OUT?

SELECT * FROM sales
SELECT 
	date,
	SUM (units) AS daily_unit_sold
	FROM sales
	WHERE date BETWEEN '2017-02-01' AND '2017-02-28'
	GROUP BY 1;
-----------------------------------------
SELECT 
	date,
	SUM (units) AS daily_unit_sold
	FROM sales
	WHERE date BETWEEN '2017-01-01' AND '2017-01-31'
	GROUP BY 1


-----------------

SELECT 
	SUM (daily_unit_sold)
	FROM
	(SELECT 
	date,
	SUM (units) AS daily_unit_sold
	FROM sales
	WHERE date BETWEEN '2017-01-01' AND '2017-01-31'
	GROUP BY 1) AS SUBQUERY;

SELECT 
	SUM (daily_unit_sold)
	FROM
	(SELECT 
	date,
	SUM (units) AS daily_unit_sold
	FROM sales
	WHERE date BETWEEN '2017-02-01' AND '2017-02-28'
	GROUP BY 1) AS SUBQUERY;


SELECT 
	SUM (daily_unit_sold)
	FROM
	(SELECT 
	date,
	SUM (units) AS daily_unit_sold
	FROM sales
	WHERE date BETWEEN '2017-03-01' AND '2017-03-31'
	GROUP BY 1) AS SUBQUERY;



SELECT 
	SUM (daily_unit_sold)
	FROM
	(SELECT 
	date,
	SUM (units) AS daily_unit_sold
	FROM sales
	WHERE date BETWEEN '2017-04-01' AND '2017-04-30'
	GROUP BY 1) AS SUBQUERY;
	

SELECT 
	SUM (daily_unit_sold)
	FROM
	(SELECT 
	date,
	SUM (units) AS daily_unit_sold
	FROM sales
	WHERE date BETWEEN '2017-05-01' AND '2017-5-30'
	GROUP BY 1) AS SUBQUERY;
	
-- Since previous month total mothly sales is more than the total stock at hand, the money tied down in the inventory won't last more than a month.


--QUESTION 3. ARE SALES BEING LOST WITH OUT OF STOCK PRODUCT AT CERTAIN LOCATION

SELECT * FROM total_profit;

SELECT * FROM inventory;
SELECT * FROM stores;
SELECT * FROM product;


SELECT 
 DISTINCT 
	st.store_name,
	st.store_location,
	p.product_id,
	p.product_name
FROM sales AS s 
JOIN stores AS st 
ON s.store_id = st.store_id
JOIN product AS p 
ON s.product_id = p.product_id


SELECT 
	store_location,
	store_name,
	COUNT (product_id) AS total_product
FROM (SELECT DISTINCT 
	st.store_name,
	st.store_location,
	p.product_id,
	p.product_name
FROM sales AS s JOIN stores AS st ON s.store_id = st.store_id
JOIN product AS p ON s.product_id = p.product_id) AS SUBQUERY
GROUP BY store_location, store_name
ORDER BY total_product 

-- Since there are 35 type of products, therefore any store_name that has a product count that is lesser than 35, is out of stock for some product and 'yes' losing sales.











