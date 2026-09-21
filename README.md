# 🛒 Marketplace Revenue Leakage & Gap Analysis using SQL
### Actionable insights from 15 SQL-driven business tasks

## 📌 Problem Statement
Modern online marketplaces often see healthy sales but declining profits. This gap
between revenue growth and profitability is usually caused by hidden factors —
excessive discounts, high return rates, logistics costs, and payment gateway fees.
This project designs a relational marketplace database (products, orders, discounts,
returns, logistics, payment fees) and uses SQL to uncover exactly where revenue is
leaking and support data-driven decisions.

## 🔧 Tools Used
SQL (MySQL) · Data Modeling & ER Diagrams (MySQL Workbench) · Joins, Subqueries,
CTEs, Window Functions · Data Cleaning · Business Gap Analysis

## 🧩 Database Schema
Six core tables: `products`, `orders`, `discounts`, `returns`, `logistics_cost`, `payment_fees`
— fully normalized with foreign key constraints. See the EER diagram below.

## 🧭 Approach
1. **Schema Design** — created 6 relational tables with proper foreign keys
2. **Data Cleaning** — handled nulls/blanks (standardized to "Unknown"), removed
   invalid cost/price records, validated referential integrity across all tables
3. **15 SQL Analysis Tasks** — from basic revenue/profit checks to advanced window
   functions and CTEs, each paired with a business recommendation

## 📊 Headline Numbers
| Metric | Value |
|---|---|
| Total Sales | ₹4.84 Cr |
| Total Leakage | ₹89.70L |
| Gross → Net Margin | 53.7% → 35.2% |
| Discounts + Returns Share of Leakage | 81% |

## 💡 Key Insights
- **Discounts are the #1 leakage source** (49.2%, ₹44.16L), with **returns close behind**
  (31.7%, ₹28.44L) — together driving 81% of all profit leakage
- **The worst 10 products cause 45.4% of total loss** (₹53,417) — fixing just these gives
  the biggest improvement for the least effort
- **34% of orders carry a discount**, and each one earns **48% less profit**
- **786 customers have a return rate 2x+ the marketplace average**
- **COD costs 3.5% in payment fees vs. UPI's 1.2%** — nearly 3x more expensive
- **Fashion is the weakest, least consistent category** — lowest average margin (35.45%)
  with the highest margin variation
- Some orders spend **65–83% of their value on logistics costs alone**

## ✅ Strategic Recommendations
- Prioritize fixing discounts and returns first — they drive 81% of total leakage
- Set a minimum order value/delivery charge to curb high logistics-cost orders
- Shift customers toward UPI/Wallet/Card over COD to cut payment fees
- Review pricing and supplier costs in Fashion and Beauty categories
- Fix "Unknown" payment-method and return-reason data capture at checkout
- Track discount-as-%-of-profit and return-rate as recurring monthly KPIs

## 🎯 Business Impact
Turned scattered marketplace data into a clear leakage diagnosis — showing leadership
exactly where ₹89.70L is being lost and which two levers (discounts + returns) to pull
first to recover the most profit.

---
## 🗂️ Database Schema (EER Diagram)
![Marketplace EER Diagram](./EER_Diagram_PNG.png)

## 📁 Project Files
🗄️ [Schema Creation](./01_schema_creation.sql)
🧹 [Data Cleaning](./02_data_cleaning.sql)
📈 [Analysis Tasks (15 queries)](./03_analysis_tasks.sql)
📊 [MySQL Workbench EER File](./EER_Diagram.mwb)
📑 [View Full Presentation (PPTX)](./Marketplace_Revenue_Leakage___Gap_Analysis_using_SQL.pptx)
