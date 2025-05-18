# DATA ANALYTICS ASSESSMENT

## Overview

This project delivers key customer and transaction insights using SQL across the core business tables:  
- `users_customuser`: contains user profile information  
- `savings_savingsaccount`: contains account and transaction data  
- `plans_plan`: contains product metadata (e.g., plan type: Savings or Investment)

Each question in this analysis addresses a real-world business scenario requested by internal teams such as Marketing, Finance, and Operations.

---

## Question 1: High-Value Customers with Multiple Products

### Scenario
The business wants to identify cross-selling opportunities by finding customers who have **both**:
- At least one funded **savings plan**
- At least one funded **investment plan**

### Approach
- Used the `plans_plan` table to determine which accounts are savings or investments via `plan_type_id` field.
- Filtered `savings_savingsaccount` for funded accounts (`confirmed_amount > 0`).
- Aggregated counts of savings and investment accounts per user.
- Summed total deposits (converted from kobo to Naira) by dividing by 100.
- Filtered for users having at least one of each product type.
- Ordered the results by total deposits to surface high-value customers.

---

## Question 2: Transaction Frequency Analysis

### Scenario
The finance team wants to segment customers by how often they transact.

### Approach
- Extracted transaction dates and normalized them to months using `DATE_FORMAT(transaction_date, '%Y-%m-01')`.
- Counted transactions per user per month.
- Averaged the monthly transaction counts across the total number of months each user has transacted.
- Categorized users based on frequency:
  - High Frequency: ≥ 10 transactions/month
  - Medium Frequency: 3–9 transactions/month
  - Low Frequency: ≤ 2 transactions/month
- Returned the customer count and average transactions per category by filtering the transaction category for high and medium frequency based on the desired output.

---

## Question 3: Account Inactivity Alert

### Scenario
The operations team wants to flag active accounts that haven't received inflows in the past 365 days.

### Approach
- Filtered for funded accounts with positive `confirmed_amount`.
- Used the `plans_plan` table to determine product type.
- Calculated the most recent transaction date per account.
- Used `DATEDIFF(CURDATE(), last_transaction_date)` to compute days of inactivity.
- Filtered accounts with inactivity over 365 days.
- Returned plan ID, owner ID, product type, and days since last transaction.

---

## Question 4: Customer Lifetime Value (CLV) Estimation

### Scenario
The marketing team wants a simplified model to estimate CLV.

### Assumptions
- `confirmed_amount` is in kobo, so values are divided by 100 to get Naira.
- `profit_per_transaction` is 0.1% of the transaction value.

### Approach
- Calculated `tenure_months` using the difference between `created_on` and the current date.
- Counted the total number of transactions per user.
- Computed the average profit per transaction.
- Applied the CLV formula to estimate yearly customer value.
- Sorted customers in descending order of CLV.


## Notes & Challenges

- **Kobo Conversion**: `confirmed_amount` values were converted from kobo to Naira (`/100`) to ensure accurate financial metrics.
- **Null Names**: Some users had missing `name` fields. Used `CONCAT(first_name, last_name)` to construct full names.
- **Duplicate Names**: Used `customer_id` as the unique identifier to avoid misinterpreting identical names as duplicates.
- **SQL Compatibility**: Replaced unsupported functions (e.g., `DATE_TRUNC` in MySQL) with alternatives like `DATE_FORMAT`.


