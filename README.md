# Bank Customer Churn & Retention Analysis

![Python](https://img.shields.io/badge/Python-3.x-blue?logo=python)
![SQL](https://img.shields.io/badge/SQL-Google%20BigQuery-orange?logo=googlecloud)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?logo=powerbi)
![Excel](https://img.shields.io/badge/Excel-Report-green?logo=microsoftexcel)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

---

## Business Problem

A retail bank is experiencing a **20.37% customer churn rate** — meaning 1 in 5 customers is leaving. The business needs to understand **who is churning, why, and which segments to prioritise for retention** to reduce revenue loss from high-value customer exits.

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| Python (Pandas, NumPy, Matplotlib) | Data cleaning, EDA, statistical analysis |
| SQL (Google BigQuery) | Business KPI queries, segmentation analysis |
| Power BI (DAX, Power Query) | Interactive dashboard, KPI reporting |
| Microsoft Excel | Summary report, Pivot Tables, VLOOKUP |

---

## Project Structure

```
bank-customer-churn-analysis/
│
├── README.md
├── data/
│   └── churn_cleaned.csv
│
├── notebooks/
│   └── churn_eda.ipynb
│
├── sql/
│   └── churn_queries.sql
│
├── excel/
│   └── Churn_Summary_Report.xlsx
│
└── dashboard/
    └── churn_dashboard.pbix
```

---

## Dataset

- **Source:** [Bank Customer Churn Prediction — Kaggle](https://www.kaggle.com/datasets/shubhammeshram579/bank-customer-churn-prediction)
- **Size:** 10,000 customer records, 14 columns
- **Key columns:** Geography, Gender, Age, Balance, NumOfProducts, IsActiveMember, Exited (churn label)

---

## Methodology

### Phase 1 — Data Cleaning & EDA (Python)

- Validated 10,000 customer records across 14 columns — checking for nulls, duplicates, and data type inconsistencies
- Engineered two new features: `ChurnLabel` (Churned/Retained) and `AgeGroup` (18-30, 31-45, 46-60, 60+)
- Answered 8 business questions through exploratory analysis with supporting visualisations

### Phase 2 — SQL Analysis (Google BigQuery)

- Developed 10 business-driven SQL queries covering churn rate by geography, gender, age group, product count, and active membership status
- Applied window functions to rank geographies by churn performance
- Identified high-value churned customers (balance > $100,000) for targeted retention analysis

### Phase 3 — Excel Summary Report

- Built management-ready summary report with 3 Pivot Tables, VLOOKUP-driven geography lookup, conditional formatting, and charts

### Phase 4 — Power BI Dashboard

- Developed interactive dashboard with DAX-driven KPI cards, slicers, matrix visual, and churn rate charts
- Dashboard updates dynamically across all visuals when geography, gender, or active membership filters are applied

---

## Key Findings

| # | Finding | Business Implication |
|---|---|---|
| 1 | Overall churn rate is **20.37%** | 1 in 5 customers is leaving the bank |
| 2 | **Germany** has the highest churn at **32.44%** | Nearly double France (16.15%) and Spain (16.67%) |
| 3 | **Female** customers churn more (**25.07%**) than male (**16.46%**) | Gender-specific retention strategies needed |
| 4 | **Age group 46–60** has the highest churn at **51.12%** | Over half of customers in this group are leaving |
| 5 | Customers with **3–4 products** churn at **82–100%** | More products does NOT improve retention |
| 6 | Churned customers have **higher average balances** ($91,108 vs $72,745) | High-value customers are leaving disproportionately |
| 7 | **Inactive members** churn at **26.85%** vs active members at **14.27%** | Engagement is the most actionable retention lever |
| 8 | **German females aged 46–60** churn at **69.17%** | Highest risk segment — priority for retention campaigns |

---

## Business Recommendations

**Priority 1 — Targeted retention campaign for German females aged 46–60**
This segment churns at 69.17% — the highest in the dataset. A focused outreach programme combining personalised relationship management and competitive product offers would have the highest expected ROI of any retention investment.

**Priority 2 — Re-engagement programme for inactive members**
Inactive members churn at nearly double the rate of active members (26.85% vs 14.27%). Digital re-engagement campaigns — app notifications, personalised offers, proactive relationship calls — represent the most scalable retention lever available.

**Priority 3 — Investigate high-balance customer exits**
Churned customers hold significantly higher average balances ($91,108 vs $72,745). This suggests the bank may be losing its most profitable customers to competitor offers. A qualitative exit survey programme for high-balance churners would identify the root cause.

---

## Dashboard Preview

> <img width="676" height="368" alt="image" src="https://github.com/user-attachments/assets/4bf1d0b6-d8cf-4225-a723-33b8a2b5d0c2" />


**Dashboard features:**
- 5 KPI cards: Total Customers, Total Churned, Churn Rate %, Avg Balance (Churned), Avg Age (Churned)
- Donut chart: Overall Churned vs Retained split
- Bar charts: Churn Rate by Geography, Age Group, Number of Products
- Matrix visual: Churn Rate by Geography × Gender
- Interactive slicers: Geography, Gender, Active Membership status

---

## SQL Highlights

```sql
-- Query 9: Top 5 High-Risk Customer Segments
SELECT
  Geography,
  Gender,
  CASE
    WHEN Age BETWEEN 18 AND 30 THEN '18-30'
    WHEN Age BETWEEN 31 AND 45 THEN '31-45'
    WHEN Age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
  END AS age_group,
  COUNT(*) AS total_customers,
  SUM(Exited) AS churned_customers,
  ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM `bank-churn-analysis.bank_churn.customers`
GROUP BY Geography, Gender, age_group
HAVING total_customers > 50
ORDER BY churn_rate_pct DESC
LIMIT 5;
```

**Result:** German females aged 46–60 — churn rate **69.17%**

---

## How to Run This Project

**Python EDA:**
```bash
# Open the notebook
jupyter notebook notebooks/churn_eda.ipynb
```

**SQL Queries:**
- Upload `data/churn_cleaned.csv` to Google BigQuery
- Create dataset: `bank_churn`, table: `customers`
- Run queries from `sql/churn_queries.sql` one at a time

**Power BI Dashboard:**
- Open `dashboard/churn_dashboard.pbix` in Power BI Desktop
- Refresh data connection to point to your local `churn_cleaned.csv`

---

## About the Analyst

**Deepa Thomas**
MSc in Applied Statistics & Data Analytics — Amrita Vishwa Vidyapeetham University

- LinkedIn: [linkedin.com/in/deepa-thomas-1a957826a](https://linkedin.com/in/deepa-thomas-1a957826a)
- GitHub: [github.com/deepa905](https://github.com/deepa905)
- Email: deepatk916@gmail.com

---

*This project was built as part of a self-directed analytics portfolio to demonstrate end-to-end data analysis skills across Python, SQL, Power BI, and Excel.*
