CREATE DATABASE E_commerce;

USE E_commerce;

CREATE TABLE products 
(
    product_id INT PRIMARY KEY,
    category VARCHAR(50),
    sub_category VARCHAR(30),
    brand VARCHAR(30),
    supplier_id INT,
    cost_price DECIMAL(10,2),
    mrp DECIMAL(10,2),
    weight_kg DECIMAL(6,2),
    launch_date DATE
);

Select *
From products;

Select Count(*)
From products;

Set Foreign_Key_Checks = 0;

CREATE TABLE payment_fees 
(
    payment_method VARCHAR(20) PRIMARY KEY,
    fee_percentage DECIMAL(5,2),
    settlement_days INT
);

INSERT INTO payment_fees
(payment_method, fee_percentage, settlement_days)
VALUES
('Unknown', 0.00, 0);

Select *
From payment_fees;

Select Count(*)
From payment_fees;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    product_id INT,
    quantity INT,
    selling_price DECIMAL(10,2),
    order_status VARCHAR(20),
    payment_method VARCHAR(20),
    order_channel VARCHAR(20),
    warehouse_id INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (payment_method) REFERENCES payment_fees(payment_method)
);

Select *
From orders;

Select Count(*)
From orders;

CREATE TABLE discounts (
    discount_id INT PRIMARY KEY,
    order_id INT,
    discount_amount DECIMAL(10,2),
    discount_type VARCHAR(20),
    coupon_code VARCHAR(20),
    is_stackable CHAR(1),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

Select *
From discounts;

Select Count(*)
From discounts;

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_id INT,
    return_flag CHAR(1),
    return_reason VARCHAR(50),
    return_initiated_date DATE,
    refund_mode VARCHAR(20),
    refund_status VARCHAR(20),
    customer_fault_flag CHAR(1),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

Select *
From returns;

Select Count(*)
From returns;

ALTER TABLE returns
MODIFY COLUMN customer_fault_flag VARCHAR(20);

CREATE TABLE logistics_cost (
    logistics_id INT PRIMARY KEY,
    order_id INT,
    shipping_cost DECIMAL(10,2),
    reverse_shipping_cost DECIMAL(10,2),
    delivery_days INT,
    delivery_status VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

Select *
From logistics_cost;

Select Count(*)
From logistics_cost;

Set Foreign_Key_Checks = 1;