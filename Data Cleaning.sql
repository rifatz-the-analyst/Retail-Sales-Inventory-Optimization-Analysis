SELECT
product_id,
product_category,
product_name,
CAST(substring(product_cost,2,length(product_cost)) AS DECIMAL) product_cost,
CAST(substring(product_price,2,length(product_price)) AS DECIMAL) product_price
FROM products
WHERE product_id IS NULL
OR product_category IS NULL
OR product_name IS NULL
OR CAST(substring(product_cost,2,length(product_cost)) AS DECIMAL) IS NULL
OR CAST(substring(product_price,2,length(product_price)) AS DECIMAL) IS NULL;

CREATE TABLE products_clean AS
SELECT
product_id,
product_category,
product_name,
CAST(substring(product_cost,2,length(product_cost)) AS DECIMAL) product_cost,
CAST(substring(product_price,2,length(product_price)) AS DECIMAL) product_price
FROM products;

SELECT 
str_to_date(dates, '%m/%d/%Y') dates,
year(str_to_date(dates, '%m/%d/%Y')) years,
month(str_to_date(dates, '%m/%d/%Y')) months
FROM calendar
WHERE str_to_date(dates, '%m/%d/%Y') IS NULL;

CREATE TABLE calendar_clean AS
SELECT 
str_to_date(dates, '%m/%d/%Y') dates,
year(str_to_date(dates, '%m/%d/%Y')) years,
month(str_to_date(dates, '%m/%d/%Y')) months
FROM calendar;

SELECT
store_id,
store_name,
store_city,
store_location,
store_open_date
FROM stores
WHERE store_id IS NULL
OR store_name IS NULL
OR store_city IS NULL
OR store_location IS NULL
OR store_open_date IS NULL;

CREATE TABLE stores_clean AS
SELECT
store_id,
substring(store_name, 11, length(store_name)) store_name,
store_city,
store_location,
store_open_date
FROM stores;

SELECT
s.sales_id,
s.date,
s.store_id,
s.product_id,
s.units,
p.product_cost,
p.product_price,
s.units * p.product_cost cogs,
s.units * p.product_price revenue
FROM sales s
LEFT JOIN products_clean p
ON s.product_id = p.product_id;

CREATE TABLE sales_clean AS
SELECT
s.sales_id,
s.date,
s.store_id,
s.product_id,
s.units,
p.product_cost,
p.product_price,
s.units * p.product_cost cogs,
s.units * p.product_price revenue
FROM sales s
LEFT JOIN products_clean p
ON s.product_id = p.product_id
;