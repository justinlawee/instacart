SELECT
  f.user_id,
  f.product_id,
  f.total_orders,
  f.total_reorders,
  f.reorder_rate,
  f.max_order_number,
  f.days_since_last_order,
  -- label: was this product reordered in the current (train) order?
  CASE WHEN t.product_id IS NOT NULL THEN 1 ELSE 0 END AS reordered_label
FROM {{ ref('fct_user_product_features') }} f
JOIN {{ ref('orders') }} o
  ON f.user_id = o.user_id
  AND o.eval_set = 'train'
LEFT JOIN {{ source('raw', 'order_products_train') }} t
  ON o.order_id = t.order_id
  AND f.product_id = t.product_id
