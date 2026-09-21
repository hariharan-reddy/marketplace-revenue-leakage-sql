SELECT *
FROM Products;

SELECT *
FROM products
WHERE cost_price <= 0
OR cost_price > mrp;

SET SQL_SAFE_UPDATES = 0;

-- discounts, returns, logistics_cost, orders, products,

DELETE FROM discounts
WHERE order_id IN 
(
    SELECT order_id 
    FROM orders
    WHERE product_id IN 
(
	SELECT product_id 
	FROM products
	WHERE cost_price <= 0 
    OR cost_price > mrp
)
);

DELETE FROM returns
WHERE order_id IN 
(
    SELECT order_id 
    FROM orders
    WHERE product_id IN 
    (
	SELECT product_id 
    FROM products
	WHERE cost_price <= 0 
    OR cost_price > mrp
)
);

DELETE FROM logistics_cost
WHERE order_id IN 
(
SELECT order_id 
FROM orders
WHERE product_id IN 
(
SELECT product_id 
FROM products
WHERE cost_price <= 0 
OR cost_price > mrp
)
);

DELETE FROM orders
WHERE product_id IN 
(
    SELECT product_id 
    FROM products
    WHERE cost_price <= 0 
    OR cost_price > mrp
);

DELETE FROM products
WHERE cost_price <=0
OR cost_price > mrp;
   
SELECT COUNT(*) AS product_rows_after_cleanup
FROM products
WHERE cost_price <=0
OR cost_price > mrp;


	-- Ajustable Data Should not be deleted
    
SELECT * FROM products;

Select Product_id, Category
FROM Products
WHERE Category = '' OR Category IS NULL; 

UPDATE Products
SET Category = 'UNKNOWN'
WHERE Category = '' OR Category IS NULL;    
	
Select Product_id, Brand
FROM Products
WHERE Brand = ''OR Brand IS NULL;    
    
UPDATE products
SET Brand = 'UNKNOWN'
WHERE Brand = '' OR brand IS NULL; 

   
    
SELECT *
FROM Orders;    
    
SELECT Product_id, Order_Status
FROM Orders
WHERE Order_Status = '' OR Order_Status IS NULL;

UPDATE Orders
SET Order_Status = 'UNKNOWN'
WHERE Order_Status = '' OR Order_Status IS NULL;     
    
Select Product_id, Order_Channel
FROM Orders
WHERE Order_Channel = '' OR Order_Channel IS NULL;    
    
UPDATE Orders
SET Order_Channel = 'UNKNOWN'
WHERE Order_Channel = '' OR Order_Channel IS NULL;     
       
    
    
SELECT *
FROM discounts;    

SELECT Order_id, discount_type, Coupon_code, is_stackable
FROM discounts
WHERE discount_type = ''
OR Coupon_code = ''
OR is_stackable = ''
OR discount_type IS NULL
OR Coupon_code IS NULL
OR is_stackable IS NULL;

UPDATE discounts
SET discount_type = 'UNKNOWN'
WHERE discount_type = '' OR discount_type IS NULL;     
    
UPDATE discounts
SET coupon_code = 'Unknown'
WHERE coupon_code = ''
OR coupon_code IS NULL;
   
UPDATE discounts
SET is_stackable = 'U'
WHERE is_stackable = ''
OR is_stackable IS NULL;



SELECT *
FROM returns;

SELECT Order_id, Return_reason, refund_mode, Refund_Status, Customer_fault_flag
FROM returns
WHERE Return_reason = ''
OR refund_mode = ''
OR Refund_Status = ''
OR Customer_fault_flag = ''
OR Return_reason IS NULL
OR refund_mode IS NULL
OR Refund_Status IS NULL
OR Customer_fault_flag IS NULL;

UPDATE returns
SET return_reason = 'Unknown'
WHERE return_reason = ''
OR return_reason IS NULL;

UPDATE returns
SET refund_mode = 'Unknown'
WHERE refund_mode = ''
OR refund_mode IS NULL;

UPDATE returns
SET refund_status = 'Unknown'
WHERE refund_status = ''
OR refund_status IS NULL;

UPDATE returns
SET customer_fault_flag = 'Unknown'
WHERE customer_fault_flag = ''
OR customer_fault_flag IS NULL;

UPDATE returns
SET customer_fault_flag = 'U'
WHERE customer_fault_flag = ''
OR customer_fault_flag IS NULL;



SELECT *
FROM logistics_cost;

SELECT Order_id, Delivery_Status
FROM logistics_cost
WHERE Delivery_Status = '' OR Delivery_Status IS NULL;    
     
UPDATE logistics_cost
SET  Delivery_Status = 'Unknown'
where Delivery_Status = '' OR Delivery_Status IS NULL; 



SELECT o.order_id, o.product_id
FROM orders o
LEFT JOIN products p
ON o.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT o.order_id, o.payment_method
FROM orders o
LEFT JOIN payment_fees p
ON o.payment_method = p.payment_method
WHERE p.payment_method IS NULL
AND o.payment_method IS NOT NULL;

SELECT d.discount_id, d.order_id
FROM discounts d
LEFT JOIN orders o
ON d.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT r.return_id, r.order_id
FROM returns r
LEFT JOIN orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT l.logistics_id, l.order_id
FROM logistics_cost l
LEFT JOIN orders o
ON l.order_id = o.order_id
WHERE o.order_id IS NULL;

SET SQL_SAFE_UPDATES = 1;













   