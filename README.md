# 🏢 SQL Joins Mastery Project

## 1. Introduction

This project demonstrates comprehensive SQL JOIN operations using MySQL.
It covers all major join types including **INNER JOIN, LEFT JOIN, RIGHT
JOIN, FULL OUTER JOIN, CROSS JOIN, SELF JOIN, and NATURAL JOIN**.\
The database stores customer and order information, showing practical
use of relationships and data retrieval across multiple tables.

------------------------------------------------------------------------

## 2. Database & Tables

### 🗄️ Database: `joindb`

Holds all customer and order related data with proper relationships.
Uses constraints like **PRIMARY KEY, FOREIGN KEY, NOT NULL** for data
integrity.

### 📋 Table: Customers

  ---------------------------------------------------------------------------
  customer_id   customer_name   email               city         manager_id
  ------------- --------------- ------------------- ------------ ------------
  1             John Doe        john@email.com      New York     NULL

  2             Jane Smith      jane@email.com      Los Angeles  1

  3             Bob Johnson     bob@email.com       Chicago      1

  4             Alice Brown     alice@email.com     Houston      2

  5             Charlie Wilson  charlie@email.com   Phoenix      2
  ---------------------------------------------------------------------------

### 📋 Table: Orders

  order_id   customer_id   order_date   amount
  ---------- ------------- ------------ --------
  101        1             2024-01-15   150.00
  102        1             2024-01-20   200.00
  103        2             2024-01-18   75.50
  104        3             2024-01-22   300.00
  105        5             2024-01-25   125.00

### 📋 Table: Products

  product_id   product_name   price
  ------------ -------------- --------
  201          Laptop         800.00
  202          Mouse          25.00
  203          Keyboard       45.00

### 📋 Table: Order_Items

  order_item_id   order_id   product_id   quantity
  --------------- ---------- ------------ ----------
  301             101        201          1
  302             101        202          2
  303             102        203          1
  304             103        202          3
  305             104        201          2

------------------------------------------------------------------------

## 3. SQL JOIN Queries Explained

### 🔗 INNER JOIN

``` sql
SELECT 
    c.customer_name,
    o.order_id,
    o.order_date,
    o.amount
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id;
```

**Sample Output:**

  customer_name    order_id   order_date   amount
  ---------------- ---------- ------------ --------
  John Doe         101        2024-01-15   150.00
  John Doe         102        2024-01-20   200.00
  Jane Smith       103        2024-01-18   75.50
  Bob Johnson      104        2024-01-22   300.00
  Charlie Wilson   105        2024-01-25   125.00

------------------------------------------------------------------------

### ◀️ LEFT JOIN

``` sql
SELECT 
    c.customer_name,
    o.order_id,
    o.order_date,
    o.amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_name;
```

**Sample Output:**

  customer_name    order_id   order_date   amount
  ---------------- ---------- ------------ --------
  Alice Brown      NULL       NULL         NULL
  Bob Johnson      104        2024-01-22   300.00
  Charlie Wilson   105        2024-01-25   125.00
  Jane Smith       103        2024-01-18   75.50
  John Doe         101        2024-01-15   150.00
  John Doe         102        2024-01-20   200.00

------------------------------------------------------------------------

### ▶️ RIGHT JOIN

``` sql
SELECT 
    o.order_id,
    o.order_date,
    o.amount,
    COALESCE(c.customer_name, 'No Customer') as customer_name
FROM Customers c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date;
```

**Sample Output:**

  order_id   order_date   amount   customer_name
  ---------- ------------ -------- ----------------
  101        2024-01-15   150.00   John Doe
  103        2024-01-18   75.50    Jane Smith
  102        2024-01-20   200.00   John Doe
  104        2024-01-22   300.00   Bob Johnson
  105        2024-01-25   125.00   Charlie Wilson

------------------------------------------------------------------------

### 🔄 FULL OUTER JOIN (Simulated)

``` sql
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
```

**Sample Output:**

  customer_id   customer_name    order_id   amount
  ------------- ---------------- ---------- --------
  1             John Doe         101        150.00
  1             John Doe         102        200.00
  2             Jane Smith       103        75.50
  3             Bob Johnson      104        300.00
  4             Alice Brown      NULL       NULL
  5             Charlie Wilson   105        125.00

------------------------------------------------------------------------

### ❌ CROSS JOIN

``` sql
SELECT 
    c.customer_name,
    o.order_id
FROM Customers c
CROSS JOIN Orders o
ORDER BY c.customer_name, o.order_id;
```

**Sample Output (25 rows):**

  customer_name    order_id
  ---------------- ----------
  Alice Brown      101
  Alice Brown      102
  Alice Brown      103
  Alice Brown      104
  Alice Brown      105
  Bob Johnson      101
  Bob Johnson      102
  Bob Johnson      103
  Bob Johnson      104
  Bob Johnson      105
  Charlie Wilson   101
  Charlie Wilson   102
  Charlie Wilson   103
  Charlie Wilson   104
  Charlie Wilson   105
  Jane Smith       101
  Jane Smith       102
  Jane Smith       103
  Jane Smith       104
  Jane Smith       105
  John Doe         101
  John Doe         102
  John Doe         103
  John Doe         104
  John Doe         105

------------------------------------------------------------------------

### 🔄 SELF JOIN

``` sql
SELECT 
    emp.customer_name AS employee,
    mgr.customer_name AS manager
FROM Customers emp
LEFT JOIN Customers mgr ON emp.manager_id = mgr.customer_id;
```

**Sample Output:**

  employee         manager
  ---------------- ------------
  John Doe         NULL
  Jane Smith       John Doe
  Bob Johnson      John Doe
  Alice Brown      Jane Smith
  Charlie Wilson   Jane Smith

------------------------------------------------------------------------

### 🔗 MULTIPLE TABLE JOIN

``` sql
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
```

**Sample Output:**

  customer_name   order_id   product_name   quantity   total_price
  --------------- ---------- -------------- ---------- -------------
  John Doe        101        Laptop         1          800.00
  John Doe        101        Mouse          2          50.00
  John Doe        102        Keyboard       1          45.00
  Jane Smith      103        Mouse          3          75.00
  Bob Johnson     104        Laptop         2          1600.00

------------------------------------------------------------------------

### 🌿 NATURAL JOIN

``` sql
SELECT 
    customer_id,
    customer_name,
    order_id,
    order_date
FROM Customers
NATURAL JOIN Orders;
```

**Sample Output:**

  customer_id   customer_name    order_id   order_date
  ------------- ---------------- ---------- ------------
  1             John Doe         101        2024-01-15
  1             John Doe         102        2024-01-20
  2             Jane Smith       103        2024-01-18
  3             Bob Johnson      104        2024-01-22
  5             Charlie Wilson   105        2024-01-25

------------------------------------------------------------------------

### 📊 JOIN WITH AGGREGATION

``` sql
SELECT 
    c.customer_name,
    COUNT(o.order_id) as total_orders,
    COALESCE(SUM(o.amount), 0) as total_spent,
    COALESCE(AVG(o.amount), 0) as average_order_value
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;
```

**Sample Output:**

  customer_name    total_orders   total_spent   average_order_value
  ---------------- -------------- ------------- ---------------------
  Bob Johnson      1              300.00        300.00
  John Doe         2              350.00        175.00
  Charlie Wilson   1              125.00        125.00
  Jane Smith       1              75.50         75.50
  Alice Brown      0              0.00          0.00

------------------------------------------------------------------------

### 🎯 COMPLEX JOIN WITH CONDITIONS

``` sql
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
```

**Sample Output:**

  --------------------------------------------------------------------------------------------------------
  customer_id   customer_name   city      order_id   order_date   amount   order_category   order_status
  ------------- --------------- --------- ---------- ------------ -------- ---------------- --------------
  Alice Brown   Alice Brown     Houston   NULL       NULL         NULL     NULL             No Orders

  Bob Johnson   Bob Johnson     Chicago   104        2024-01-22   300.00   High Value       Has Orders

  John Doe      John Doe        New York  101        2024-01-15   150.00   Medium Value     Has Orders

  John Doe      John Doe        New York  102        2024-01-20   200.00   Medium Value     Has Orders
  --------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------

```

### 🎯 JOIN Optimization Tips

-   Use indexes on join columns\
-   Select specific columns instead of `SELECT *`\
-   Filter early with `WHERE` clause\
-   Avoid functions on join columns\
-   Use appropriate join types for your use case

------------------------------------------------------------------------

## 5. Summary

✅ Created comprehensive join database with multiple related tables\
✅ Implemented all major join types: INNER, LEFT, RIGHT, FULL OUTER,
CROSS, SELF, NATURAL\
✅ Demonstrated practical use cases for each join type\
✅ Covered multi-table joins and complex join scenarios\
✅ Included aggregation with joins for analytical queries
