
-- Schema Creation

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Sample Data Inserts

INSERT INTO customers VALUES 
(1, 'Aadi', 'aadi@example.com', 'Delhi'),
(2, 'Riya', 'riya@example.com', 'Mumbai'),
(3, 'Kabir', 'kabir@example.com', 'Delhi'),
(4, 'Sneha', 'sneha@example.com', 'Kolkata');

INSERT INTO products VALUES 
(101, 'Keyboard', 1200.00),
(102, 'Mouse', 600.00),
(103, 'Monitor', 7500.00),
(104, 'Laptop', 55000.00);

INSERT INTO orders VALUES 
(1001, 1, '2024-04-10'),
(1002, 2, '2024-04-11'),
(1003, 1, '2024-04-12'),
(1004, 3, '2024-04-12');

INSERT INTO order_items VALUES 
(1, 1001, 101, 1),
(2, 1001, 102, 2),
(3, 1002, 104, 1),
(4, 1003, 103, 1),
(5, 1004, 101, 2);


-- Analysis Queries

-- Basic SELECT + WHERE + ORDER BY
SELECT customer_name, city FROM customers WHERE city = 'Delhi' ORDER BY customer_name;

-- Aggregate + GROUP BY
SELECT city, COUNT(*) AS total_customers FROM customers GROUP BY city ORDER BY total_customers DESC;

-- INNER JOIN
SELECT o.order_id, c.customer_name, o.order_date 
FROM orders o 
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- LEFT JOIN
SELECT c.customer_name, o.order_id 
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Subquery
SELECT customer_name FROM customers 
WHERE customer_id IN (
    SELECT customer_id FROM orders 
    GROUP BY customer_id 
    HAVING COUNT(*) > 1
);

-- View Creation
CREATE VIEW customer_order_summary AS
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- Index Creation
CREATE INDEX idx_customer_id ON orders(customer_id);
