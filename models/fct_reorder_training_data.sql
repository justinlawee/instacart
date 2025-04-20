-- models/fct_reorder_training_data.sql

/* 
Description: Creates ML training dataset
→ Labels each user-product pair with 1 or 0 depending on whether that product was reordered in the user’s train order (most recent order among training users only) → used as ML training dataset
    In the orders.csv file, each order is assigned an eval_set value:
        1. prior → historical orders used for feature engineering.
        2. train → the user’s most recent order, used for training your model.
        3. test → the user’s most recent order, without labels, used for prediction
*/

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
JOIN {{ ref('dim_orders') }} o
  ON f.user_id = o.user_id
  AND o.eval_set = 'train'
LEFT JOIN {{ source('raw', 'order_products_train') }} t
  ON o.order_id = t.order_id
  AND f.product_id = t.product_id
