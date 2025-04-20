SELECT
  user_id,
  product_id,
  NULL::FLOAT AS reorder_probability,
  CURRENT_TIMESTAMP AS scored_at
FROM {{ ref('instacart_training_input') }}
