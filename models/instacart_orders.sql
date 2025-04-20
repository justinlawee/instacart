-- models/instacart.sql
-- Description: Raw order data with user and time info

select * from {{ source('raw', 'orders') }}
