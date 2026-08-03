# 📊 Enterprise Retail Data Warehouse Project
**Built with Databricks, PySpark, SQL, and Medallion Architecture**

## 🎯 Project Overview
This project integrates two siloed retail systems (**CRM** and **ERP**) to build a centralized Data Warehouse (**Single Source of Truth**). By utilizing **Medallion Architecture**, the raw transactional data is refined across three progressive layers (Bronze, Silver, and Gold) to ensure data quality and provide high-performance business insights using a **Star Schema**.

## 🏗️ Architecture Layers & Implementation
1. **01_bronze.py**: Handles raw data ingestion from CSV files directly into **Delta Tables** via Unity Catalog Volumes (stored strictly as string formats to ensure zero data loss).
2. **02_silver.py**: Performs data deduplication using **Window Functions** (`row_number`), analytical transformations, structural normalization, and strict casting.
3. **03_gold.sql**: Establishes instant reporting data models via **SQL Views** based on a high-performance star schema, creating optimized dimension tables (`dim_customers`, `dim_products`) and a transactional fact table (`fact_sales`).

## 🛠️ Data Quality Challenges Engineered & Resolved
During development, several critical data quality errors were discovered and programmatically resolved in the **Silver Layer**:
* **Column & Identity Resolution**: Merged fragmented `cst_firstname` and `cst_lastname` columns from the CRM system into a standardized `cst_name` column.
* **Schema Evolution**: Standardized legacy ERP naming acronyms by mapping `BDATE` to `birthdate` and `GEN` to `gender` to maintain system alignment.
* **Corrupted Datetime Records**: Handled corrupted or dummy timestamp entries (e.g., records containing string `'0'`) using PySpark's `try_to_date` function, preventing pipeline breakage and gracefully returning `NULL` for bad inputs.
