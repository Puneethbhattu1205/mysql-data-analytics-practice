CREATE DATABASE Pizza_hut ;


CREATE TABLE orders (
    Order_id INT NOT NULL PRIMARY KEY,
    Order_date DATE NOT NULL,
    Order_time TIME NOT NULL
);


CREATE TABLE order_details_id (
    Order_details_id INT NOT NULL PRIMARY KEY,
    Order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    Quantity INT NOT NULL
);
    
SET GLOBAL local_infile = 1;
    
LOAD DATA LOCAL INFILE 'C:/Users/MI/Desktop/Puna/MySQL_Files/Pizza_sales/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS ;

LOAD DATA LOCAL INFILE 'C:/Users/MI/Desktop/Puna/MySQL_Files/Pizza_sales/order_details.csv'
INTO TABLE order_details_id
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM pizzas ;
SELECT * FROM pizza_types ;
SELECT * FROM orders ;
SELECT * FROM order_details ;



-- BASIC TASKS :

-- 1. Retrieve the total number of orders placed. 

SELECT 
    COUNT(order_id) AS Total_Orders
FROM
    orders;


-- 2. Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),2) AS Total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;


-- 3. Identify the highest-priced pizza.

SELECT 
    pt.`name`, pz.price
FROM
    pizza_types pt
        JOIN
    pizzas pz ON pt.pizza_type_id = pz.pizza_type_id
ORDER BY pz.price DESC
LIMIT 1;


-- 4. Identify the most common pizza size ordered.

SELECT 
    pz.size, COUNT(od.Order_details_id) AS Order_count
FROM
    pizzas pz
        JOIN
    order_details od ON pz.pizza_id = od.pizza_id
GROUP BY pz.size
ORDER BY Order_count DESC;


-- 5. List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pt.`name` AS Pizza_name, SUM(od.Quantity) QTY
FROM
    pizza_types pt
        JOIN
    pizzas pz ON pt.pizza_type_id = pz.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = pz.pizza_id
GROUP BY pt.`name`
ORDER BY QTY DESC
LIMIT 5;



-- INTERMEDIATE TASKS :

-- 6. Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pt.category, SUM(od.Quantity) AS QTY
FROM
    pizza_types pt
        JOIN
    pizzas pz ON pt.pizza_type_id = pz.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = pz.pizza_id
GROUP BY pt.category
ORDER BY QTY DESC; 


-- 7. Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS `Hour`, COUNT(order_id) AS Order_count
FROM
    orders
GROUP BY `Hour`
ORDER BY Order_count DESC;


-- 8. Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;


-- 9. Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(Qty),0) Avg_pizzas_ordered_perday
FROM
    (SELECT 
        ods.order_date, SUM(od.quantity) AS Qty
    FROM
        orders ods
    JOIN order_details od ON od.order_id = ods.Order_id
    GROUP BY ods.order_date) AS Order_qty;

-- 10. Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pt.`name`, SUM(od.quantity * pz.price) AS Revenue
FROM
    pizza_types pt
        JOIN
    pizzas pz ON pz.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON pz.pizza_id = od.pizza_id
GROUP BY pt.`name`
ORDER BY Revenue DESC
LIMIT 3;



-- ADVANCE TASKS :

-- 1. Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pt.category,
    ROUND(SUM(od.quantity * pz.price) / (SELECT 
            ROUND(SUM(order_details.quantity * pizzas.price),
                        2) AS Total_revenue
        FROM
            order_details
                JOIN
            pizzas ON pizzas.pizza_id = order_details.pizza_id) *100,2) AS `Revenue%`
FROM
    pizza_types pt
        JOIN
    pizzas pz ON pz.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON pz.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY `Revenue%` DESC;

-- 2. Analyze the cumulative revenue generated over time.

SELECT order_date, ROUND(SUM(Revenue) OVER(ORDER BY order_date),2) AS Cum_Revenue
FROM 
(SELECT odr.order_date, SUM(od.quantity * pz.price) AS Revenue
FROM ORDERS odr
JOIN order_details od ON od.Order_id = odr.order_id
JOIN pizzas pz ON pz.pizza_id = od.pizza_id 
GROUP BY odr.order_date) AS Sales ;


-- 3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT category, name, Revenue, RN
FROM
(SELECT category, name, Revenue, RANK() OVER(PARTITION BY category ORDER BY Revenue DESC) AS RN
FROM
(SELECT pzt.category, pzt.name, ROUND(SUM((od.quantity) * pz.price),2) AS Revenue
FROM pizzas pz 
JOIN order_details od ON pz.pizza_id = od.pizza_id
JOIN pizza_types pzt ON pzt.pizza_type_id = pz.pizza_type_id 
GROUP BY pzt.category, pzt.name) AS A) AS B
WHERE RN <= 3 ;