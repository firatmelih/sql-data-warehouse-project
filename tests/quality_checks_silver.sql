/*
===========================================================
Quality Checks
===========================================================
Script Purpose:
    This script performs various quality checks for data
    consistency, accuracy, 
    and standardization across the 'silver' layer. It 
    includes checks for:

    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found
    during the checks.
==========================================================
*/


-- ========== silver.crm_cust_info check =================
-- ================= CHECK 1/6 ===========================

-- check for NULLs or duplicates in primary key
-- expectation: no result
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- check for unwanted spaces
-- expectation: no result
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- data standardization & consistency
-- expectation: no null, standart categories fitting to documentation
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

-- check general image
-- expectation: clean beautiful table
SELECT * FROM silver.crm_cust_info


-- ========== silver.crm_prd_info check ==================
-- ================= CHECK 2/6 ===========================

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


-- ========== silver.crm_sales_details check =============
-- ================= CHECK 3/6 ===========================

-- check for invalid date orders and out of range dates
-- expectation: no result
SELECT sls_order_dt FROM bronze.crm_sales_details
WHERE sls_order_dt <=0
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101


-- check for invalid date orders and out of range dates
-- expectation: no result
SELECT sls_ship_dt FROM bronze.crm_sales_details
WHERE sls_ship_dt <=0
OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101


-- check for invalid date orders and out of range dates
-- expectation: no result
SELECT sls_due_dt FROM bronze.crm_sales_details
WHERE sls_due_dt <=0
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101


-- check data consistency for sales = price * quantity equation
-- expectation: no result
SELECT
sls_quantity,
sls_price,
sls_sales
FROM silver.crm_sales_details
WHERE sls_sales != sls_price * sls_quantity 
OR sls_sales IS NULL 
OR sls_price IS NULL 
OR sls_quantity IS NULL
OR sls_sales <= 0
OR sls_price <= 0
OR sls_quantity <= 0

-- check general image
-- expectation: clean beautiful table
SELECT * FROM silver.crm_sales_details

-- ========== silver.erp_cust_az12 check =================
-- ================= CHECK 4/6 ===========================

-- check out of range dates
-- expectation: no result
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate > GETDATE()
OR bdate < '1900-01-01'

-- data standardization & consistency
-- no null, standart categories fitting to documentation
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;

-- ========== silver.erp_loc_a101 check ==================
-- ================= CHECK 5/6 ===========================

-- data standardization & consistency
-- no null, standart categories fitting to documentation
SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;

-- ========== silver.erp_px_cat_g1v2 check ===============
-- ================= CHECK 6/6 ===========================

-- check for unwanted Spaces
-- expectation: no result
SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- data standardization & consistency
-- no null, standart categories fitting to documentation
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;
