-- models/dim_products.sql

SELECT
  p.product_id,
  p.product_name,
  a.aisle_id,
  a.aisle AS aisle_name,
  d.department_id,
  d.department AS department_name
FROM {{ ref('products') }} p
JOIN {{ ref('aisles') }} a ON p.aisle_id = a.aisle_id
JOIN {{ ref('departments') }} d ON p.department_id = d.department_id
