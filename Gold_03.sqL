-- 1. dim_products
CREATE OR REPLACE VIEW retail_dwh.gold.dim_products AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY p.prd_id) AS product_key,
    p.prd_id AS product_id,
    p.prd_line AS product_line,
    p.prd_cost AS product_cost,
    c.cat AS category,
    c.subcat AS subcategory
FROM retail_dwh.silver.crm_prd_info p
LEFT JOIN retail_dwh.silver.erp_px_cat_g1v2 c ON p.prd_id = c.id;

-- 2. dim_customers
CREATE OR REPLACE VIEW retail_dwh.gold.dim_customers AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY c.cst_id) AS customer_key,
    c.cst_id AS customer_id,
    c.cst_name AS customer_name,
    COALESCE(c.cst_gndr, e.gender, 'n-a') AS gender,
    e.birthdate,
    l.cntry AS country
FROM retail_dwh.silver.crm_cust_info c
LEFT JOIN retail_dwh.silver.erp_cust_az12 e ON c.cst_id = e.cid
LEFT JOIN retail_dwh.silver.erp_loc_a101 l ON c.cst_id = l.cid;

-- 3. fact_sales
CREATE OR REPLACE VIEW retail_dwh.gold.fact_sales AS
SELECT 
    dc.customer_key,
    dp.product_key,
    s.sls_order_dt AS order_date,
    s.sls_quantity AS quantity,
    s.sls_price AS price,
    s.sls_sales AS sales_amount
FROM retail_dwh.silver.crm_sales_details s
LEFT JOIN retail_dwh.gold.dim_customers dc ON s.sls_cust_id = dc.customer_id
LEFT JOIN retail_dwh.gold.dim_products dp ON s.sls_prd_key = dp.product_id;
