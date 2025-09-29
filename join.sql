-- =============================================
-- DATABASE AND TABLES CREATION
-- =============================================

-- Create database
CREATE DATABASE joindb;
USE joindb;

-- Create Customers table with manager_id included from start
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(50),
    manager_id INT
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);

-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10,2)
);

-- Create Order_Items table
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT
);

-- =============================================
-- SAMPLE DATA INSERTION
-- =============================================

-- Insert data into Customers table with manager_id
INSERT INTO Customers (customer_id, customer_name, email, city, manager_id) VALUES
(1, 'John Doe', 'john@email.com', 'New York', NULL),
(2, 'Jane Smith', 'jane@email.com', 'Los Angeles', 1),
(3, 'Bob Johnson', 'bob@email.com', 'Chicago', 1),
(4, 'Alice Brown', 'alice@email.com', 'Houston', 2),
(5, 'Charlie Wilson', 'charlie@email.com', 'Phoenix', 2);

-- Insert data into Orders table
INSERT INTO Orders (order_id, customer_id, order_date, amount) VALUES
(101, 1, '2024-01-15', 150.00),
(102, 1, '2024-01-20', 200.00),
(103, 2, '2024-01-18', 75.50),
(104, 3, '2024-01-22', 300.00),
(105, 5, '2024-01-25', 125.00);

-- Insert data into Products table
INSERT INTO Products VALUES 
(201, 'Laptop', 800.00),
(202, 'Mouse', 25.00),
(203, 'Keyboard', 45.00);

-- Insert data into Order_Items table
INSERT INTO Order_Items VALUES 
(301, 101, 201, 1),
(302, 101, 202, 2),
(303, 102, 203, 1),
(304, 103, 202, 3),
(305, 104, 201, 2);

-- Add foreign key constraint
ALTER TABLE Orders 
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id);

-- =============================================
-- JOIN QUERIES
-- =============================================

-- QUERY 1: INNER JOIN - Customers with Orders
SELECT 
    c.customer_name,
    o.order_id,
    o.order_date,
    o.amount
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id;

-- QUERY 2: LEFT JOIN - All Customers (Including Those Without Orders)
SELECT 
    c.customer_name,
    o.order_id,
    o.order_date,
    o.amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_name;

-- QUERY 3: RIGHT JOIN - All Orders with Customer Info
SELECT 
    o.order_id,
    o.order_date,
    o.amount,
    COALESCE(c.customer_name, 'No Customer') as customer_name
FROM Customers c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date;

-- QUERY 4: Simulated FULL OUTER JOIN
SELECT 
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
UNION
SELECT 
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.amount
FROM Orders o
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- QUERY 5: CROSS JOIN - All Possible Combinations
SELECT 
    c.customer_name,
    o.order_id
FROM Customers c
CROSS JOIN Orders o
ORDER BY c.customer_name, o.order_id
LIMIT 10;

-- QUERY 6: SELF JOIN - Employee Manager Relationships
SELECT 
    emp.customer_name AS employee,
    mgr.customer_name AS manager
FROM Customers emp
LEFT JOIN Customers mgr ON emp.manager_id = mgr.customer_id;

-- QUERY 7: Multiple Table Join
SELECT 
    c.customer_name,
    o.order_id,
    p.product_name,
    oi.quantity,
    (p.price * oi.quantity) as total_price
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Order_Items oi ON o.order_id = oi.order_id
INNER JOIN Products p ON oi.product_id = p.product_id;

-- QUERY 8: NATURAL JOIN
SELECT 
    customer_id,
    customer_name,
    order_id,
    order_date
FROM Customers
NATURAL JOIN Orders;

-- QUERY 9: Join with Aggregation
SELECT 
    c.customer_name,
    COUNT(o.order_id) as total_orders,
    COALESCE(SUM(o.amount), 0) as total_spent,
    COALESCE(AVG(o.amount), 0) as average_order_value
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

-- QUERY 10: Complex Join with Multiple Conditions
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date,
    o.amount,
    CASE 
        WHEN o.amount > 200 THEN 'High Value'
        WHEN o.amount > 100 THEN 'Medium Value' 
        ELSE 'Low Value'
    END as order_category,
    CASE 
        WHEN o.order_id IS NULL THEN 'No Orders'
        ELSE 'Has Orders'
    END as order_status
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE (o.amount > 100 OR o.amount IS NULL)
AND c.city IN ('New York', 'Los Angeles', 'Chicago', 'Houston')
ORDER BY c.customer_name, o.order_date;
