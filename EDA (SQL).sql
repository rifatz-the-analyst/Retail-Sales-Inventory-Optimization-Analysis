--  SALES PERFORMANCE
SELECT *,
	round((total_revenue - LAG(total_revenue) OVER()) / LAG(total_revenue) OVER() * 100, 2) mom_growth
FROM
	(SELECT
		year(date) order_year, 
		month(date) order_month, 
		SUM(revenue) total_revenue 
	FROM sales_clean
	GROUP BY year(date), month(date))t;

SELECT *,
	round((total_revenue - LAG(total_revenue) OVER(PARTITION BY order_month ORDER BY order_year))/
    LAG(total_revenue) OVER(PARTITION BY order_month ORDER BY order_year) * 100, 2) yoy_growth
FROM
	(SELECT
		year(date) order_year, 
		month(date) order_month, 
		SUM(revenue) total_revenue 
	FROM sales_clean
	GROUP BY year(date), month(date))t;
    
-- STORES PERFORMANCE

SELECT 
	st.store_name, 
	total_revenue,
	round(total_revenue / SUM(total_revenue) OVER() * 100, 2) sales_contribution,
	profit,
	round(profit / SUM(profit) OVER() * 100, 2) profit_contribution
FROM
	(SELECT 
		store_id, 
		SUM(units) unit_sold, 
		SUM(revenue) total_revenue,
		SUM(cogs) total_cogs,
		SUM(revenue - cogs) profit
	FROM sales_clean
	GROUP BY store_id) sl
JOIN stores_clean st
ON sl.store_id = st.store_id
ORDER BY total_revenue DESC;

SELECT st.store_city, SUM(revenue) total_revenue
FROM sales_clean sl
LEFT JOIN stores_clean st
ON sl.store_id = st.store_id
GROUP BY st.store_city
ORDER BY SUM(revenue) DESC;

SELECT st.store_location, SUM(revenue) total_revenue
FROM sales_clean sl
LEFT JOIN stores_clean st
ON sl.store_id = st.store_id
GROUP BY st.store_location
ORDER BY SUM(revenue) DESC;

-- PRODUCT PERFORMANCE
SELECT
	category,
	total_revenue,
	round(total_revenue/SUM(total_revenue) OVER()*100,2) sales_contribution,
    total_revenue - total_cogs profit,
    round((total_revenue - total_cogs)/SUM(total_revenue - total_cogs) OVER()*100,2) profit_contribution
FROM
	(SELECT 
		p.product_category category, 
		SUM(s.revenue) total_revenue,
        SUM(s.cogs) total_cogs
    FROM products_clean p
	JOIN sales_clean s
	ON p.product_id = s.product_id
	GROUP BY p.product_category
	ORDER BY SUM(s.revenue) DESC)t;

SELECT 
	p.product_name, 
	s.unit_sold, 
	s.total_revenue,
	round(s.total_revenue / SUM(s.total_revenue) OVER() * 100, 2) sales_contribution,
    s.total_revenue-s.total_cogs profit,
    round((s.total_revenue-s.total_cogs) / SUM(s.total_revenue-s.total_cogs) OVER()*100, 2) profit_contribution
FROM
	(SELECT 
		product_id, 
		SUM(units) unit_sold, 
		SUM(revenue) total_revenue,
		SUM(cogs) total_cogs
    FROM sales_clean
	GROUP BY product_id) s
JOIN products_clean p
ON s.product_id = p.product_id
ORDER BY s.total_revenue DESC;

SELECT p.product_name, s.unit_sold, s.total_revenue,
round(s.total_revenue / SUM(s.total_revenue) OVER() * 100, 2) sales_contribution
FROM
(SELECT product_id, SUM(units) unit_sold, SUM(revenue) total_revenue FROM sales_clean
GROUP BY product_id) s
JOIN products_clean p
ON s.product_id = p.product_id
ORDER BY s.unit_sold DESC;

SELECT sl.product_id, p.product_name, sl.profit FROM
(SELECT product_id product_id, SUM(revenue-cogs) profit FROM sales_clean
GROUP BY product_id) sl
JOIN products_clean p
ON sl.product_id = p.product_id
ORDER BY sl.profit DESC;

-- INVENTORY ANALYSIS

SELECT p.product_name, s.unit_sold unit_sold, sum(i.stock_on_hand) stock_on_hand FROM
(SELECT product_id, SUM(units) unit_sold FROM sales_clean
GROUP BY product_id
ORDER BY SUM(units) DESC) s
JOIN products_clean p
ON s.product_id = p.product_id
LEFT JOIN inventory i
ON p.product_id = i.product_id
GROUP BY p.product_name, s.unit_sold;

SELECT *, round(unit_sold/stock_on_hand,2) inventory_turn_over FROM
(SELECT p.product_name product_name, s.unit_sold unit_sold, sum(i.stock_on_hand) stock_on_hand FROM
(SELECT product_id, SUM(units) unit_sold FROM sales_clean
GROUP BY product_id
ORDER BY SUM(units) DESC) s
JOIN products_clean p
ON s.product_id = p.product_id
LEFT JOIN inventory i
ON p.product_id = i.product_id
GROUP BY p.product_name, s.unit_sold)t
ORDER BY unit_sold/stock_on_hand DESC;

WITH unit_sales AS
(SELECT date, SUM(units) units_sold FROM sales_clean
GROUP BY date)
SELECT round(AVG(units_sold), 2) daily_sold FROM unit_sales;

WITH unit_sales AS
	(SELECT 
		product_id, 
		date, 
		SUM(units) units_sold 
    FROM sales_clean
	WHERE date BETWEEN '2023-07-01' AND '2023-09-30'
	GROUP BY product_id, date),
avg_daily AS
	(SELECT 
		product_id, 
		round(AVG(units_sold), 2) avg_daily_sold 
    FROM unit_sales
	GROUP BY product_id),
stock AS
	(SELECT 
		p.product_id, 
		p.product_name, 
		total_stock 
    FROM
		(SELECT 
			product_id, 
			SUM(stock_on_hand) total_stock 
        FROM inventory
		GROUP BY product_id) i
	JOIN products_clean p
	ON p.product_id = i.product_id)
SELECT 
	p.product_name, 
	a.avg_daily_sold, 
	round(s.total_stock/a.avg_daily_sold,2) coverage_days
FROM avg_daily a
JOIN products_clean p
ON p.product_id = a.product_id
JOIN stock s
ON s.product_id = a.product_id
ORDER BY a.avg_daily_sold DESC;

SELECT 
p.product_name, 
total_stock 
FROM
	(SELECT 
    product_id, 
    SUM(stock_on_hand) total_stock 
    FROM inventory
	GROUP BY product_id) i
JOIN products_view p
ON p.product_id = i.product_id;

SELECT SUM(stock_on_hand) total_stock FROM inventory