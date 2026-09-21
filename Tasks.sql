 USE E_commerce; 
  
  -- TASK 1 : Revenue vs Profit Reality
  
SELECT
SUM(o.quantity * o.selling_price) AS total_sales_revenue,
SUM(o.quantity * p.cost_price) AS total_cost,
SUM((o.quantity * o.selling_price) - (o.quantity * p.cost_price)) 
AS total_profit
FROM orders o
JOIN products p
ON o.product_id = p.product_id; 


  -- TASK 2 : Category-wise Sales & Profit
  
SELECT p.category,
SUM(o.quantity * o.selling_price) AS total_sales,
SUM(o.quantity * p.cost_price) AS total_cost,
SUM((o.quantity * o.selling_price) - (o.quantity * p.cost_price)) AS total_profit
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_profit DESC;  


  -- TASK 3 : Loss-Making Products
 
SELECT
p.product_id,
p.category,
p.sub_category,
p.brand,
SUM(o.quantity * o.selling_price) AS total_sales,
SUM(o.quantity * p.cost_price) AS total_cost,
SUM((o.quantity * o.selling_price) - (o.quantity * p.cost_price)) AS total_profit
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY
p.product_id,
p.category,
p.sub_category,
p.brand
HAVING total_profit < 0
ORDER BY total_profit ASC;


  -- TASK 4 : Discount Usage Overview

SELECT
COUNT(DISTINCT order_id) AS discounted_orders,
SUM(discount_amount) AS total_discount_amount
FROM discounts
WHERE discount_amount > 0;


  -- TASK 5 : Payment Method Popularity

SELECT
o.payment_method,
COUNT(DISTINCT o.order_id) AS total_orders,
SUM(o.quantity * o.selling_price) AS total_sales
FROM orders o
GROUP BY o.payment_method
ORDER BY total_sales DESC;


  -- TASK 6 : Discount vs Profit Gap
  
SELECT
CASE
WHEN EXISTS 
(
SELECT 1
FROM discounts d
WHERE d.order_id = o.order_id
AND d.discount_amount > 0
)
THEN 'Discounted'
ELSE 'Non-Discounted'
END AS order_type,

COUNT(DISTINCT o.order_id) AS total_orders,
AVG((o.quantity * o.selling_price) - (o.quantity * p.cost_price)
- COALESCE
((SELECT SUM(d.discount_amount)
FROM discounts d
WHERE d.order_id = o.order_id),0)) AS average_profit_per_order
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY order_type;  


  -- TASK 7 : Return Impact on Revenue

SELECT
SUM(o.quantity * o.selling_price) AS revenue_lost,
SUM((o.quantity * o.selling_price) - (o.quantity * p.cost_price)) AS profit_lost
FROM orders o
JOIN products p
ON o.product_id = p.product_id
JOIN returns r
ON o.order_id = r.order_id
WHERE r.return_flag = 'Y';


  -- TASK 8 : Return Reason Analysis

SELECT
r.return_reason,
COUNT(DISTINCT r.return_id) AS total_returns,
SUM(o.quantity * o.selling_price) AS revenue_lost
FROM returns r
JOIN orders o
ON r.order_id = o.order_id
WHERE r.return_flag = 'Y'
GROUP BY r.return_reason
ORDER BY revenue_lost DESC;


  -- TASK 9 : Logistics Cost Burden
  
SELECT
o.order_id, o.quantity * o.selling_price AS order_value,
(l.shipping_cost + l.reverse_shipping_cost) AS total_logistics_cost,
ROUND(((l.shipping_cost + l.reverse_shipping_cost) / (o.quantity * o.selling_price)) * 100, 2) 
AS logistics_cost_percentage
FROM orders o
JOIN logistics_cost l
ON o.order_id = l.order_id
WHERE
(l.shipping_cost + l.reverse_shipping_cost)
> (o.quantity * o.selling_price * 0.20)
ORDER BY logistics_cost_percentage DESC;  


  -- TASK 10 : Payment Fee Leakage
  
SELECT
o.payment_method,
ROUND(SUM(o.quantity * o.selling_price), 2) AS total_sales,
ROUND(SUM((o.quantity * o.selling_price) * pf.fee_percentage / 100), 2) AS total_payment_fee,
ROUND(SUM((o.quantity * o.selling_price) - (o.quantity * p.cost_price)
- ((o.quantity * o.selling_price) * pf.fee_percentage / 100)), 2) AS profit_after_payment_fee
FROM orders o
JOIN products p
ON o.product_id = p.product_id

JOIN payment_fees pf
ON o.payment_method = pf.payment_method
GROUP BY o.payment_method
ORDER BY total_payment_fee DESC;


-- TASK 11 : Revenue Leakage Breakdown

WITH discount_total AS (
SELECT order_id, SUM(discount_amount) AS discount_amount
FROM discounts
GROUP BY order_id
),

return_flag_check AS (
SELECT order_id, MAX(CASE WHEN return_flag = 'Y' THEN 1 ELSE 0 END) AS is_returned
FROM returns
GROUP BY order_id
),

logistics_total AS (
SELECT order_id, SUM(shipping_cost + reverse_shipping_cost) AS logistics_cost
FROM logistics_cost
GROUP BY order_id
)

SELECT
o.order_id,
ROUND(o.quantity * o.selling_price, 2) AS order_value,
ROUND(COALESCE(dt.discount_amount, 0), 2) AS discount_loss,

CASE 
WHEN rf.is_returned = 1 THEN ROUND(o.quantity * o.selling_price, 2)
ELSE 0
END AS return_loss,

ROUND(COALESCE(lt.logistics_cost, 0), 2) AS logistics_loss,

ROUND(o.quantity * o.selling_price * pf.fee_percentage / 100, 2) AS payment_fee_loss,

ROUND(
COALESCE(dt.discount_amount, 0) +
(CASE WHEN rf.is_returned = 1 THEN o.quantity * o.selling_price ELSE 0 END) +
COALESCE(lt.logistics_cost, 0) +
(o.quantity * o.selling_price * pf.fee_percentage / 100), 2) AS total_leakage

FROM orders o
LEFT JOIN discount_total dt ON o.order_id = dt.order_id
LEFT JOIN return_flag_check rf ON o.order_id = rf.order_id
LEFT JOIN logistics_total lt ON o.order_id = lt.order_id
JOIN payment_fees pf ON o.payment_method = pf.payment_method

ORDER BY total_leakage DESC;


  -- TASK 12 : Product Profit Ranking
  
  SELECT
p.product_id,
p.category,
p.sub_category,
p.brand,

SUM((o.quantity * o.selling_price) - (o.quantity * p.cost_price)) AS total_profit,
RANK() OVER (ORDER BY
SUM((o.quantity * o.selling_price) - (o.quantity * p.cost_price)) DESC) AS profit_rank

FROM orders o
JOIN products p
ON o.product_id = p.product_id

GROUP BY
p.product_id,
p.category,
p.sub_category,
p.brand
ORDER BY profit_rank;

 
  -- TASK 13 : Category Margin Stability

SELECT
p.category,
COUNT(*) AS total_orders,

ROUND(AVG(((o.quantity * o.selling_price) - (o.quantity * p.cost_price)) / (o.quantity * o.selling_price) * 100), 2) 
AS average_profit_margin,

ROUND(STDDEV((((o.quantity * o.selling_price) - (o.quantity * p.cost_price)) / (o.quantity * o.selling_price)) * 100), 2)
 AS margin_variation

FROM orders o
JOIN products p
ON o.product_id = p.product_id

WHERE o.quantity * o.selling_price > 0
GROUP BY p.category
ORDER BY margin_variation DESC;


  -- TASK 14 : High-Risk Customers

WITH customer_return_rate AS (
SELECT
o.customer_id,
COUNT(DISTINCT o.order_id) AS total_orders,

COUNT(
DISTINCT CASE
WHEN r.return_flag = 'Y'
THEN o.order_id
END
) AS returned_orders,

COUNT(
DISTINCT CASE
WHEN r.return_flag = 'Y'
THEN o.order_id
END
) 
/ COUNT(DISTINCT o.order_id) * 100 AS return_rate

FROM orders o
LEFT JOIN returns r
ON o.order_id = r.order_id
GROUP BY o.customer_id),

marketplace_average AS 
(
SELECT
AVG(return_rate) AS avg_return_rate
FROM customer_return_rate
)

SELECT
c.customer_id,
c.total_orders,
c.returned_orders,
ROUND(c.return_rate, 2) AS return_rate,
ROUND(m.avg_return_rate, 2) AS marketplace_avg_return_rate

FROM customer_return_rate c
CROSS JOIN marketplace_average m

WHERE c.return_rate > (m.avg_return_rate * 2)
AND c.total_orders >= 2
ORDER BY c.return_rate DESC;


WITH customer_return_rate AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,

        COUNT(
            DISTINCT CASE
                WHEN r.return_flag = 'Y'
                THEN o.order_id
            END
        ) AS returned_orders,

        COUNT(
            DISTINCT CASE
                WHEN r.return_flag = 'Y'
                THEN o.order_id
            END
        ) / COUNT(DISTINCT o.order_id) * 100 AS return_rate

    FROM orders o
    LEFT JOIN returns r
        ON o.order_id = r.order_id

    GROUP BY o.customer_id
),

marketplace_average AS (
    SELECT
        SUM(returned_orders) / SUM(total_orders) * 100
        AS avg_return_rate
    FROM customer_return_rate
)

SELECT
    COUNT(*) AS high_risk_customers

FROM customer_return_rate c
CROSS JOIN marketplace_average m

WHERE c.return_rate > m.avg_return_rate * 2
AND c.total_orders >= 2;

  -- TASK 15 : Executive Profitability Summary

WITH d AS (
SELECT order_id, SUM(discount_amount) discount
FROM discounts
GROUP BY order_id
),

r AS (
SELECT order_id, MAX(return_flag) returned
FROM returns
GROUP BY order_id
),

l AS (
SELECT order_id, SUM(shipping_cost + reverse_shipping_cost) logistics
FROM logistics_cost
GROUP BY order_id
)

SELECT
ROUND(SUM(o.quantity * o.selling_price), 2) total_sales,
ROUND(SUM(o.quantity * p.cost_price), 2) total_product_cost,
ROUND(SUM(COALESCE(d.discount, 0)), 2) total_discounts,
ROUND(SUM(IF(r.returned = 'Y', o.quantity * o.selling_price, 0)), 2) total_returns_loss,
ROUND(SUM(COALESCE(l.logistics, 0)), 2) total_logistics_cost,
ROUND(SUM(o.quantity * o.selling_price * pf.fee_percentage / 100), 2) total_payment_fees,

ROUND(
SUM(o.quantity * o.selling_price)
- SUM(o.quantity * p.cost_price)
- SUM(COALESCE(d.discount, 0))
- SUM(IF(r.returned = 'Y', o.quantity * o.selling_price, 0))
- SUM(COALESCE(l.logistics, 0))
- SUM(o.quantity * o.selling_price * pf.fee_percentage / 100), 2
) final_net_profit

FROM orders o
JOIN products p
ON o.product_id = p.product_id

JOIN payment_fees pf
ON o.payment_method = pf.payment_method

LEFT JOIN d
ON o.order_id = d.order_id

LEFT JOIN r
ON o.order_id = r.order_id

LEFT JOIN l
ON o.order_id = l.order_id;























