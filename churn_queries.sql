-- ============================================================
-- RETAIL BANKING CUSTOMER CHURN & RETENTION ANALYSIS
-- SQL Analysis using Google BigQuery
-- Author: Deepa Thomas
-- GitHub: github.com/deepa905
-- Tool: Google BigQuery
-- Dataset: bank_churn.customers (10,000 records)
-- ============================================================


-- ============================================================
-- QUERY 1: Overall Churn Rate
-- Business Question: What percentage of customers are 
-- churning overall?
-- ============================================================

SELECT
  COUNT(*)                                              AS total_customers,
  SUM(Exited)                                           AS total_churned,
  ROUND(SUM(Exited) * 100.0 / COUNT(*), 2)             AS churn_rate_pct
FROM `bank-churn-analysis.bank_churn.customers`;

-- Result: 10,000 total customers | 2,037 churned | 20.37% churn rate


-- ============================================================
-- QUERY 2: Churn Rate by Geography
-- Business Question: Which country has the highest churn rate?
-- ============================================================

SELECT
  Geography,
  COUNT(*)                                              AS total_customers,
  SUM(Exited)                                           AS churned_customers,
  ROUND(SUM(Exited) * 100.0 / COUNT(*), 2)             AS churn_rate_pct
FROM `bank-churn-analysis.bank_churn.customers`
GROUP BY Geography
ORDER BY churn_rate_pct DESC;

-- Result: Germany 32.44% | Spain 16.67% | France 16.15%
-- Insight: Germany churns at nearly double the rate of France and Spain


-- ============================================================
-- QUERY 3: Churn Rate by Gender
-- Business Question: Do female customers churn more than 
-- male customers?
-- ============================================================

SELECT
  Gender,
  COUNT(*)                                              AS total_customers,
  SUM(Exited)                                           AS churned_customers,
  ROUND(SUM(Exited) * 100.0 / COUNT(*), 2)             AS churn_rate_pct
FROM `bank-churn-analysis.bank_churn.customers`
GROUP BY Gender
ORDER BY churn_rate_pct DESC;

-- Result: Female 25.07% | Male 16.46%
-- Insight: Female customers churn at a significantly higher rate


-- ============================================================
-- QUERY 4: Average Financial Metrics by Churn Status
-- Business Question: How do churned and retained customers 
-- differ on key financial metrics?
-- ============================================================

SELECT
  CASE WHEN Exited = 1 
       THEN 'Churned' 
       ELSE 'Retained' 
  END                                                   AS customer_status,
  ROUND(AVG(Balance), 2)                                AS avg_balance,
  ROUND(AVG(CreditScore), 2)                            AS avg_credit_score,
  ROUND(AVG(Age), 1)                                    AS avg_age,
  COUNT(*)                                              AS total_customers
FROM `bank-churn-analysis.bank_churn.customers`
GROUP BY Exited
ORDER BY Exited DESC;

-- Result: Churned avg balance $91,108 vs Retained $72,745
-- Insight: High-value customers are leaving disproportionately


-- ============================================================
-- QUERY 5: Churn Rate by Number of Products
-- Business Question: Does having more products increase 
-- or decrease churn?
-- ============================================================

SELECT
  NumOfProducts,
  COUNT(*)                                              AS total_customers,
  SUM(Exited)                                           AS churned_customers,
  ROUND(SUM(Exited) * 100.0 / COUNT(*), 2)             AS churn_rate_pct
FROM `bank-churn-analysis.bank_churn.customers`
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

-- Result: 1 product 27.71% | 2 products 7.58% | 
--         3 products 82.71% | 4 products 100%
-- Insight: More products does NOT improve retention beyond 2


-- ============================================================
-- QUERY 6: Active vs Inactive Member Churn
-- Business Question: Are inactive members more likely 
-- to churn than active members?
-- ============================================================

SELECT
  CASE WHEN IsActiveMember = 1 
       THEN 'Active' 
       ELSE 'Inactive' 
  END                                                   AS member_status,
  COUNT(*)                                              AS total_customers,
  SUM(Exited)                                           AS churned_customers,
  ROUND(SUM(Exited) * 100.0 / COUNT(*), 2)             AS churn_rate_pct
FROM `bank-churn-analysis.bank_churn.customers`
GROUP BY IsActiveMember
ORDER BY churn_rate_pct DESC;

-- Result: Inactive 26.85% vs Active 14.27%
-- Insight: Inactive members churn at nearly double the rate


-- ============================================================
-- QUERY 7: High Value Customers Who Churned
-- Business Question: Which high value customers 
-- (balance > $100,000) have already left the bank?
-- ============================================================

SELECT
  Geography,
  Gender,
  Age,
  ROUND(Balance, 2)                                     AS balance,
  CreditScore,
  NumOfProducts,
  CASE WHEN IsActiveMember = 1 
       THEN 'Active' 
       ELSE 'Inactive' 
  END                                                   AS member_status
FROM `bank-churn-analysis.bank_churn.customers`
WHERE Exited = 1
  AND Balance > 100000
ORDER BY Balance DESC
LIMIT 20;

-- Insight: Identifies the bank's highest-value lost customers
-- for targeted win-back campaign analysis


-- ============================================================
-- QUERY 8: Churn Rate by Age Group
-- Business Question: Which age group is at highest risk 
-- of churning?
-- ============================================================

SELECT
  CASE
    WHEN Age BETWEEN 18 AND 30 THEN '18-30'
    WHEN Age BETWEEN 31 AND 45 THEN '31-45'
    WHEN Age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
  END                                                   AS age_group,
  COUNT(*)                                              AS total_customers,
  SUM(Exited)                                           AS churned_customers,
  ROUND(SUM(Exited) * 100.0 / COUNT(*), 2)             AS churn_rate_pct
FROM `bank-churn-analysis.bank_churn.customers`
GROUP BY age_group
ORDER BY churn_rate_pct DESC;

-- Result: 46-60 at 51.12% | 60+ at 24.78% | 
--         31-45 at 19.62% | 18-30 at 7.50%
-- Insight: Over half of customers aged 46-60 are leaving


-- ============================================================
-- QUERY 9: Top 5 High Risk Customer Segments
-- Business Question: Which specific combination of Geography,
-- Gender, and Age Group has the highest churn rate?
-- ============================================================

SELECT
  Geography,
  Gender,
  CASE
    WHEN Age BETWEEN 18 AND 30 THEN '18-30'
    WHEN Age BETWEEN 31 AND 45 THEN '31-45'
    WHEN Age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
  END                                                   AS age_group,
  COUNT(*)                                              AS total_customers,
  SUM(Exited)                                           AS churned_customers,
  ROUND(SUM(Exited) * 100.0 / COUNT(*), 2)             AS churn_rate_pct
FROM `bank-churn-analysis.bank_churn.customers`
GROUP BY Geography, Gender, age_group
HAVING total_customers > 50
ORDER BY churn_rate_pct DESC
LIMIT 5;

-- Result:
-- 1. Germany | Female | 46-60 → 69.17% (266 customers, 184 churned)
-- 2. Germany | Male   | 46-60 → 65.25% (236 customers, 154 churned)
-- 3. France  | Female | 46-60 → 54.80% (354 customers, 194 churned)
-- 4. Germany | Female | 60+   → 50.94% (53 customers, 27 churned)
-- 5. Spain   | Female | 46-60 → 46.04% (202 customers, 93 churned)
--
-- KEY INSIGHT: German female customers aged 46-60 are the 
-- single highest risk segment at 69.17% churn rate
-- Recommendation: Priority retention campaign for this segment


-- ============================================================
-- QUERY 10: Window Function — Rank Geographies by Churn Rate
-- Business Question: How do geographies rank against each 
-- other on churn performance?
-- (Demonstrates advanced SQL — Window Function usage)
-- ============================================================

SELECT
  Geography,
  COUNT(*)                                              AS total_customers,
  SUM(Exited)                                           AS churned_customers,
  ROUND(SUM(Exited) * 100.0 / COUNT(*), 2)             AS churn_rate_pct,
  RANK() OVER (
    ORDER BY SUM(Exited) * 100.0 / COUNT(*) DESC
  )                                                     AS churn_rank
FROM `bank-churn-analysis.bank_churn.customers`
GROUP BY Geography
ORDER BY churn_rank;

-- Result: Germany Rank 1 (32.44%) | Spain Rank 2 (16.67%) | 
--         France Rank 3 (16.15%)
-- Note: RANK() OVER() adds ranking without collapsing data rows
-- unlike GROUP BY alone — demonstrating window function usage


-- ============================================================
-- END OF ANALYSIS
-- 
-- Summary of SQL Concepts Used:
-- COUNT, SUM, AVG, ROUND        → Queries 1-10
-- GROUP BY                      → Queries 2-10
-- ORDER BY                      → Queries 1-10
-- WHERE with multiple conditions → Query 7
-- CASE WHEN / ELSE              → Queries 4, 6, 8, 9
-- HAVING                        → Query 9
-- LIMIT                         → Queries 7, 9
-- RANK() OVER() Window Function → Query 10
-- ============================================================
