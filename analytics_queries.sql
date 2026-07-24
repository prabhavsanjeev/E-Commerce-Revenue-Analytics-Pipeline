-- ====================================================================
-- E-Commerce Advanced SQL Analytics Suite
-- Features: CTEs, Window Functions (LAG, SUM OVER), Self-Joins, Cohorts
-- ====================================================================

-- --------------------------------------------------------------------
-- QUERY 1: Month-over-Month (MoM) Revenue & Growth Rate
-- --------------------------------------------------------------------
WITH monthly_revenue AS (
    SELECT 
        strftime('%Y-%m', invoice_date) AS sales_month,
        ROUND(SUM(quantity * unit_price), 2) AS total_revenue
    FROM transactions
    GROUP BY sales_month
)
SELECT 
    sales_month,
    total_revenue,
    LAG(total_revenue, 1) OVER (ORDER BY sales_month) AS previous_month_revenue,
    ROUND(
        ((total_revenue - LAG(total_revenue, 1) OVER (ORDER BY sales_month)) / 
        LAG(total_revenue, 1) OVER (ORDER BY sales_month)) * 100, 2
    ) AS mom_growth_percentage
FROM monthly_revenue;


-- --------------------------------------------------------------------
-- QUERY 2: Customer Cumulative Lifetime Spend (CLV Trend)
-- --------------------------------------------------------------------
WITH customer_orders AS (
    SELECT 
        customer_id,
        invoice_date,
        ROUND(SUM(quantity * unit_price), 2) AS order_value
    FROM transactions
    GROUP BY customer_id, invoice_date
)
SELECT 
    customer_id,
    invoice_date,
    order_value,
    ROUND(SUM(order_value) OVER (
        PARTITION BY customer_id 
        ORDER BY invoice_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS cumulative_lifetime_spend
FROM customer_orders;


-- --------------------------------------------------------------------
-- QUERY 3: Churn Prediction (At-Risk VIP Customers)
-- --------------------------------------------------------------------
WITH customer_summary AS (
    SELECT 
        customer_id,
        MAX(invoice_date) AS last_purchase_date,
        ROUND(SUM(quantity * unit_price), 2) AS total_spend,
        COUNT(DISTINCT invoice_no) AS total_orders
    FROM transactions
    GROUP BY customer_id
),
dataset_max_date AS (
    SELECT MAX(invoice_date) AS max_date FROM transactions
)
SELECT 
    cs.customer_id,
    cs.total_spend,
    cs.total_orders,
    CAST((JULIANDAY(d.max_date) - JULIANDAY(cs.last_purchase_date)) AS INT) AS days_since_last_purchase,
    'At-Risk VIP' AS customer_status
FROM customer_summary cs
CROSS JOIN dataset_max_date d
WHERE CAST((JULIANDAY(d.max_date) - JULIANDAY(cs.last_purchase_date)) AS INT) > 90
  AND cs.total_spend > 1000
ORDER BY cs.total_spend DESC;


-- --------------------------------------------------------------------
-- QUERY 4: Market Basket Analysis (Cross-Selling Bundles)
-- --------------------------------------------------------------------
SELECT 
    t1.description AS product_a,
    t2.description AS product_b,
    COUNT(*) AS times_bought_together
FROM transactions t1
JOIN transactions t2 
    ON t1.invoice_no = t2.invoice_no 
    AND t1.stock_code < t2.stock_code
GROUP BY product_a, product_b
HAVING times_bought_together > 50
ORDER BY times_bought_together DESC
LIMIT 15;


-- --------------------------------------------------------------------
-- QUERY 5: Cohort Retention Base Data
-- --------------------------------------------------------------------
WITH first_purchase AS (
    SELECT 
        customer_id,
        strftime('%Y-%m-01', MIN(invoice_date)) AS cohort_month
    FROM transactions
    GROUP BY customer_id
),
activity AS (
    SELECT 
        t.customer_id,
        fp.cohort_month,
        strftime('%Y-%m-01', t.invoice_date) AS activity_month
    FROM transactions t
    JOIN first_purchase fp ON t.customer_id = fp.customer_id
)
SELECT 
    cohort_month,
    activity_month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM activity
GROUP BY cohort_month, activity_month
ORDER BY cohort_month, activity_month;