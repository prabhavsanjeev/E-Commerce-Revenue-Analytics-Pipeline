# 🛍️ End-to-End Retail Analytics Pipeline & Revenue Intelligence System

> **Author:** **Prabhav Sanjeev**  
> **Role:** Analytics Engineer / Data Analyst  

An end-to-end data engineering and advanced analytics pipeline built using **Python, SQLite, and Advanced SQL**. This project processes raw e-commerce transaction data, ingests it into a relational database, and executes complex analytical SQL queries to extract key business revenue metrics.

---

## 📌 Executive Summary & Key Highlights
* **Automated Data Ingestion:** Built a Python ETL pipeline using Pandas to clean raw Excel datasets and stream processed data into an **SQLite Relational Database**.
* **Advanced Analytical SQL Queries:** Wrote production-grade SQL utilizing **CTEs, Window Functions (`LAG`, `SUM() OVER`), Self-Joins, and Date Parsing**.
* **Business Insights Generated:**
  * **MoM Revenue Trends:** Evaluated monthly growth percentages and revenue trajectory.
  * **Customer Lifetime Value (CLV):** Calculated running cumulative spend per customer.
  * **VIP Churn Risk:** Identified high-value customers with no purchase activity for >90 days.
  * **Market Basket Analysis:** Mapped product cross-selling pairs (e.g., Green Teacup & Pink Teacup bought together 700+ times).
  * **Cohort Retention:** Tracked user decay month-over-month.

---

## 🏗️ Tech Stack & Architecture
* **Language:** Python 3.x
* **Database:** SQLite3
* **Query Language:** SQL (CTEs, Window Functions, Self-Joins)
* **Libraries:** `pandas`, `sqlite3`
* **Output:** CSV Reports (Ready for Power BI Dashboarding)

```text
[ Raw Excel Data ] ──> ( Python ETL: build_db.py ) ──> [ SQLite DB ] ──> ( SQL Analytics: run_sql_analytics.py ) ──> [ 5 Business CSV Reports ]

## 📁 Repository Structure

```text
├── build_db.py              # Ingests & cleans raw Excel data, creates SQLite DB
├── run_sql_analytics.py     # Executes SQL queries and exports CSV reports
├── analytics_queries.sql    # Clean, production-ready SQL scripts
├── ecommerce.db             # Generated SQLite Relational Database
├── 1_mom_revenue.csv        # Query Output 1: Monthly Growth
├── 2_customer_clv.csv       # Query Output 2: Cumulative Customer Spend
├── 3_at_risk_vips.csv       # Query Output 3: Churn Risk VIPs
├── 4_product_bundles.csv    # Query Output 4: Cross-sell Pairs
└── 5_cohort_retention.csv   # Query Output 5: Cohort Retention Base
