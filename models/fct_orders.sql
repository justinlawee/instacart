-- models/fct_orders.sql

/* 
Description: Aggregates order facts
→ Adds product-level aggregates to each order: total items and how many were reordered.
*/

SELECT
  o.order_id,
  o.user_id,
  o.eval_set,
  o.order_number,
  o.order_dow,
  o.order_hour_of_day,
  o.days_since_prior_order,
  COUNT(op.product_id) AS total_products,
  SUM(op.reordered) AS total_reordered
FROM {{ source('raw', 'orders') }} o
LEFT JOIN {{ source('raw','order_products_prior') }} op
  ON o.order_id = op.order_id
GROUP BY
  o.order_id,
  o.user_id,
  o.eval_set,
  o.order_number,
  o.order_dow,
  o.order_hour_of_day,
  o.days_since_prior_order