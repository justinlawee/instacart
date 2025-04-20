-- models/fct_user_product_features.sql

SELECT
  prior.user_id,
  prior.product_id,
  COUNT(*) AS total_orders,
  SUM(prior.reordered) AS total_reorders,
  AVG(prior.reordered) AS reorder_rate,
  MAX(orders.order_number) AS max_order_number,
  MAX(orders.days_since_prior_order) AS days_since_last_order
FROM {{ ref('order_products_prior') }} prior
JOIN {{ ref('orders') }} orders
  ON prior.order_id = orders.order_id
WHERE orders.eval_set = 'prior'
GROUP BY prior.user_id, prior.product_id
