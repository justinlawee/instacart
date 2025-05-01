-- models/fct_user_product_features.sql

/*
Description: Per-user/product reorder history
→ Aggregates each user-product pair’s order history, including total purchases, reorders, and time since last order.
*/

SELECT
  orders.user_id,
  prior.product_id,

  COUNT(DISTINCT prior.order_id) AS total_orders,  -- ✅ orders where user bought this product
  SUM(prior.reordered) AS total_reorders,

  CASE
    WHEN COUNT(DISTINCT prior.order_id) > 1 THEN
      SUM(prior.reordered) * 1.0 / (COUNT(DISTINCT prior.order_id) - 1)
    ELSE NULL
  END AS reorder_rate,  -- ✅ only reorders after first purchase

  MAX(orders.order_number) AS max_order_number,  -- ✅ max order where product was bought
  MAX(orders.days_since_prior_order) AS days_since_last_order

FROM {{ source('raw', 'order_products_prior') }} AS prior
JOIN {{ source('raw', 'orders') }} AS orders
