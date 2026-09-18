# Pizza-Sales-Analysis-SQL
SQL analysis of pizza restaurant sales — joins, CTEs, window functions

## 📌 Overview
A SQL-based analysis of a pizza restaurant's sales data to identify the factors behind low sales and uncover opportunities to grow revenue.

## 🎯 Business Objective
The restaurant wanted to understand which products, hours, and categories were driving (or hurting) sales, in order to make data-driven decisions on pricing, inventory, and promotions.

## 🛠️ Skills & Concepts Used
- Multi-table Joins
- CTEs (Common Table Expressions)
- Window Functions (RANK, SUM OVER — running totals)
- Aggregate Functions & Subqueries

## 🔍 Key Analysis Performed
- Total orders and total revenue calculation
- Highest-priced pizza and most common pizza size
- Top 5 most ordered pizza types
- Category-wise quantity distribution
- Order distribution by hour of day (peak hour identification)
- Average pizzas ordered per day
- **Top 3 pizza types by revenue per category** — using RANK() with PARTITION BY
- **Revenue % contribution by category** — using CTEs
- **Cumulative revenue over time** — using window functions (running total)

## 💡 Key Insights
- Identified peak ordering hours to optimize staffing
- Found top-performing pizza types and categories by revenue
- Tracked cumulative revenue growth trend over the analysis period

## 📂 Files
- `pizza_sales_analysis.sql` — Full SQL script with all queries
