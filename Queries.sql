
SELECT * FROM customers;
SELECT COUNT(*) FROM products;
SELECT * FROM orders WHERE order_status='Delivered';

SELECT city, COUNT(*) AS total_customers FROM customers GROUP BY city;
SELECT SUM(total_price) AS total_revenue FROM order_items;

SELECT product_id, SUM(quantity) AS total_sold
FROM order_items
GROUP BY product_id
ORDER BY total_sold DESC
LIMIT 5;

SELECT DATE_FORMAT(order_date,'%Y-%m') AS month, COUNT(*) AS total_orders
FROM orders
GROUP BY month;

SELECT c.customer_id, c.name, SUM(oi.total_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;

SELECT order_date, SUM(total_price) OVER (ORDER BY order_date) AS running_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id;

-- Find the Top 3 products with the highest total revenue
SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity * oi.total_price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 3;

-- Calculate Average Order Value
SELECT 
    AVG(order_total) AS average_order_value
FROM (
    SELECT 
        o.order_id,
        SUM(oi.quantity * oi.total_price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id
) AS totals;

-- Identify customers who purchased more than 5 unique products
SELECT 
    c.customer_id,
    c.name,
    COUNT(DISTINCT oi.product_id) AS unique_products_bought
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name
HAVING COUNT(DISTINCT oi.product_id) > 5;

-- Find customers who never placed an order
SELECT 
    c.customer_id, 
    c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Total revenue per month
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.quantity * oi.total_price) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;
