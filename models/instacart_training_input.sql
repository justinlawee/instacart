SELECT *
FROM {{ ref('fct_reorder_training_data') }}
WHERE total_orders >= 2
