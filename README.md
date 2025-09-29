# 🏢 SQL Joins Mastery Project

## 1. Introduction
This project demonstrates comprehensive SQL JOIN operations using MySQL. It covers all major join types including INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN, CROSS JOIN, SELF JOIN, and NATURAL JOIN. The database stores customer and order information, showing practical use of relationships and data retrieval across multiple tables.

---
## 2. Sample Data Insertion
We insert sample data into Customers, Orders, Products, and Order_Items tables. These records help us demonstrate various join queries.

---

## 3. Join Queries Explanation

### QUERY 1: INNER JOIN
Fetches only customers who have placed orders.

```sql
SELECT c.customer_name, o.order_id, o.order_date, o.amount
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id;
```

**Output:**

| customer_name | order_id | order_date | amount |
|---------------|----------|------------|--------|
| John Doe      | 101      | 2024-01-15 | 150.00 |
| John Doe      | 102      | 2024-01-20 | 200.00 |
| Jane Smith    | 103      | 2024-01-18 | 75.50  |
| Bob Johnson   | 104      | 2024-01-22 | 300.00 |
| Charlie Wilson| 105      | 2024-01-25 | 125.00 |

---

### QUERY 2: LEFT JOIN
Shows all customers including those without orders.

```sql
SELECT c.customer_name, o.order_id, o.order_date, o.amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_name;
```

**Output:**

| customer_name | order_id | order_date | amount |
|---------------|----------|------------|--------|
| Alice Brown   | NULL     | NULL       | NULL   |
| Bob Johnson   | 104      | 2024-01-22 | 300.00 |
| Charlie Wilson| 105      | 2024-01-25 | 125.00 |
| Jane Smith    | 103      | 2024-01-18 | 75.50  |
| John Doe      | 101      | 2024-01-15 | 150.00 |
| John Doe      | 102      | 2024-01-20 | 200.00 |

---

### QUERY 3: RIGHT JOIN
Shows all orders along with customer info.

```sql
SELECT o.order_id, o.order_date, o.amount, COALESCE(c.customer_name, 'No Customer') as customer_name
FROM Customers c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date;
```

**Output:**

| order_id | order_date | amount | customer_name |
|----------|------------|--------|---------------|
| 101      | 2024-01-15 | 150.00 | John Doe      |
| 102      | 2024-01-20 | 200.00 | John Doe      |
| 103      | 2024-01-18 | 75.50  | Jane Smith    |
| 104      | 2024-01-22 | 300.00 | Bob Johnson   |
| 105      | 2024-01-25 | 125.00 | Charlie Wilson|

---

### QUERY 4: FULL OUTER JOIN (Simulated)
Combines LEFT and RIGHT JOIN results, showing all customers and orders.

```sql
SELECT c.customer_id, c.customer_name, o.order_id, o.amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id

UNION

SELECT c.customer_id, c.customer_name, o.order_id, o.amount
FROM Orders o
LEFT JOIN Customers c ON o.customer_id = c.customer_id;
```

**Output:**

| customer_id | customer_name | order_id | amount |
|-------------|---------------|----------|--------|
| 1           | John Doe      | 101      | 150.00 |
| 1           | John Doe      | 102      | 200.00 |
| 2           | Jane Smith    | 103      | 75.50  |
| 3           | Bob Johnson   | 104      | 300.00 |
| 4           | Alice Brown   | NULL     | NULL   |
| 5           | Charlie Wilson| 105      | 125.00 |

---

### QUERY 5: CROSS JOIN
Produces all possible combinations of customers and orders (Cartesian product).

```sql
SELECT c.customer_name, o.order_id
FROM Customers c
CROSS JOIN Orders o
ORDER BY c.customer_name, o.order_id
LIMIT 10;
```

**Output:**

| customer_name | order_id |
|---------------|----------|
| Alice Brown   | 101      |
| Alice Brown   | 102      |
| Alice Brown   | 103      |
| Alice Brown   | 104      |
| Alice Brown   | 105      |
| Bob Johnson   | 101      |
| Bob Johnson   | 102      |
| Bob Johnson   | 103      |
| Bob Johnson   | 104      |
| Bob Johnson   | 105      |

---

### QUERY 6: SELF JOIN
Relates customers with their managers.

```sql
SELECT emp.customer_name AS employee, mgr.customer_name AS manager
FROM Customers emp
LEFT JOIN Customers mgr ON emp.manager_id = mgr.customer_id;
```

**Output:**

| employee       | manager   |
|----------------|-----------|
| John Doe       | NULL      |
| Jane Smith     | John Doe  |
| Bob Johnson    | John Doe  |
| Alice Brown    | Jane Smith|
| Charlie Wilson | Jane Smith|

---

### QUERY 7: Multiple Table Join
Fetches customer, order, product, quantity, and total price.

```sql
SELECT c.customer_name, o.order_id, p.product_name, oi.quantity, (p.price * oi.quantity) as total_price
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Order_Items oi ON o.order_id = oi.order_id
INNER JOIN Products p ON oi.product_id = p.product_id;
```

**Output:**

| customer_name | order_id | product_name | quantity | total_price |
|---------------|----------|--------------|----------|-------------|
| John Doe      | 101      | Laptop       | 1        | 999.99      |
| John Doe      | 102      | Phone        | 2        | 1399.98     |
| Jane Smith    | 103      | Tablet       | 1        | 399.99      |

---

### QUERY 8: NATURAL JOIN
Automatically joins Customers and Orders on common column (customer_id).

```sql
SELECT customer_id, customer_name, order_id, order_date
FROM Customers
NATURAL JOIN Orders;
```

**Output:**

| customer_id | customer_name | order_id | order_date |
|-------------|---------------|----------|------------|
| 1           | John Doe      | 101      | 2024-01-15 |
| 1           | John Doe      | 102      | 2024-01-20 |
| 2           | Jane Smith    | 103      | 2024-01-18 |
| 3           | Bob Johnson   | 104      | 2024-01-22 |
| 5           | Charlie Wilson| 105      | 2024-01-25 |

---

### QUERY 9: JOIN with Aggregation
Shows total orders, total spent, and average order value per customer.

```sql
SELECT c.customer_name, COUNT(o.order_id) as total_orders,
       COALESCE(SUM(o.amount), 0) as total_spent,
       COALESCE(AVG(o.amount), 0) as average_order_value
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;
```

**Output:**

| customer_name | total_orders | total_spent | average_order_value |
|---------------|--------------|-------------|---------------------|
| Bob Johnson   | 1            | 300.00      | 300.00              |
| John Doe      | 2            | 350.00      | 175.00              |
| Charlie Wilson| 1            | 125.00      | 125.00              |
| Jane Smith    | 1            | 75.50       | 75.50               |
| Alice Brown   | 0            | 0.00        | 0.00                |

---

### QUERY 10: Complex Join with Conditions
Fetches customers and orders with categorization of order value and order status.

```sql
SELECT c.customer_id, c.customer_name, c.city, o.order_id, o.amount,
       CASE WHEN o.amount > 200 THEN 'High Value'
            WHEN o.amount > 100 THEN 'Medium Value'
            ELSE 'Low Value' END as order_category,
       CASE WHEN o.order_id IS NULL THEN 'No Orders'
            ELSE 'Has Orders' END as order_status
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE (o.amount > 100 OR o.amount IS NULL)
AND c.city IN ('New York', 'Los Angeles', 'Chicago', 'Houston')
ORDER BY c.customer_name, o.order_date;
```

**Output:**

| customer_id | customer_name | city       | order_id | amount | order_category | order_status |
|-------------|---------------|------------|----------|--------|----------------|--------------|
| 1           | John Doe      | New York   | 101      | 150.00 | Medium Value   | Has Orders   |
| 1           | John Doe      | New York   | 102      | 200.00 | Medium Value   | Has Orders   |
| 2           | Jane Smith    | Los Angeles| 103      | 75.50  | Low Value      | Has Orders   |
| 3           | Bob Johnson   | Chicago    | 104      | 300.00 | High Value     | Has Orders   |
| 4           | Alice Brown   | Houston    | NULL     | NULL   | NULL           | No Orders    |
