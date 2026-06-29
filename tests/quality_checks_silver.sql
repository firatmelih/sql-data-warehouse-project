-- QUALITY CHECK SILVER

-- crm_cust_info checks:

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data Standardization & Consistency
-- no null, standart categories fitting to documentation
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

-- check general image
-- expectation: clean beautiful table
SELECT * FROM silver.crm_cust_info

-- crm_cust_info check end


-- crm_prd_info check

-- check duplicate id
-- expectation: no result
SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- check for unwanted spaces
-- expectation: no result
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- check for nulls or negative numbers
-- expectation: no result
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- data standardization & consistency
-- no null, standart categories fitting to documentation
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- check for invalid date orders
-- expectation: no result
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- check general image
-- expectation: clean beautiful table
SELECT * FROM silver.crm_prd_info

-- crm_prd_info check end

-- crm_sales_details check

-- check for invalid date orders
-- expectation: no result
SELECT sls_order_dt FROM bronze.crm_sales_details
WHERE sls_order_dt <=0
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101


-- check for invalid date orders
-- expectation: no result
SELECT sls_ship_dt FROM bronze.crm_sales_details
WHERE sls_ship_dt <=0
OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101


-- check for invalid date orders
-- expectation: no result
SELECT sls_due_dt FROM bronze.crm_sales_details
WHERE sls_due_dt <=0
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101


-- check for invalid date orders
-- expectation: no result
SELECT
sls_quantity,
sls_price,
sls_sales
FROM silver.crm_sales_details
WHERE sls_sales != sls_price * sls_quantity OR sls_sales IS NULL OR sls_price IS NULL OR sls_quantity IS NULL


-- check general image
-- expectation: clean beautiful table
SELECT * FROM silver.crm_sales_details

-- crm_sales_details check end
