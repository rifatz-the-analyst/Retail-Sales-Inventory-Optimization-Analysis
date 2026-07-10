# Metrics & Calculations

The following business metrics were developed using DAX measures in Power BI to support sales performance, profitability, and inventory optimization analysis.

| **Metric**                                  | **Formula / Calculation**                                                | **Business Purpose**                                                                                 |
| ------------------------------------------- | ------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------- |
| **Revenue**                                 | `SUM(Sales[Units] × Products[Price])`                                    | Calculates total sales revenue generated from product sales.                                         |
| **Cost**                                    | `SUM(Sales[Units] × Products[Cost])`                                     | Calculates the total cost of goods sold (COGS).                                                      |
| **Profit**                                  | `Revenue − Cost`                                                         | Measures gross profit generated from sales.                                                          |
| **Profit Margin (%)**                       | `(Profit ÷ Revenue) × 100`                                               | Measures profitability relative to revenue.                                                          |
| **Total Orders**                            | `DISTINCTCOUNT(Sales)`                                                       | Counts the total number of completed sales transactions.                                             |
| **Units Sold**                              | `SUM(Sales[Units])`                                                      | Calculates the total quantity of products sold.                                                      |
| **Average Order Value (AOV)**               | `Revenue ÷ Total Orders`                                                 | Measures the average revenue generated per transaction.                                              |
| **Revenue Contribution (%)**                | `(Product Revenue ÷ Total Revenue) × 100`                                | Measures each product's or category's contribution to overall revenue.                               |
| **Profit Contribution (%)**                 | `(Product Profit ÷ Total Profit) × 100`                                  | Measures each product's or category's contribution to total profit.                                  |
| **Year-over-Year (YoY) Revenue Growth (%)** | `((Revenue CY − Revenue PY) ÷ Revenue PY) × 100`                         | Measures revenue growth compared with the same period in the previous year.                          |
| **Average Daily Orders**                    | `Total Units Sold ÷ Number of Selling Days`                              | Estimates average daily product demand.                                                              |
| **Inventory Coverage (Days)**               | `Current Stock ÷ Average Daily Orders`                                   | Estimates how many days current inventory can satisfy expected demand.                               |
| **Excess Inventory**                        | `Actual Stock − Target Stock`                                            | Identifies inventory exceeding the target stock level.                                               |
| **Excess Inventory Value**                  | `(Actual Stock − Target Stock) × Product Cost`                           | Estimates the amount of capital tied up in excess inventory.                                         |
| **Potential Revenue Loss**                  | `(Average Daily Orders × Product Price) × (7 − Inventory Coverage Days)` | Estimates potential revenue at risk when inventory coverage falls below the 7-day minimum threshold. |
| **Compound Monthly Growth Rate (CMGR)**     | `((Ending Value ÷ Beginning Value)^(1 ÷ Number of Months)) − 1`          | Measures the average monthly growth (or decline) rate over a specified period.                       |
| **Top 25% Revenue Contribution**            | `(Revenue from Top 25% Products ÷ Total Revenue) × 100`                  | Measures the degree of revenue concentration among the highest-performing products.                  |

## Business Assumptions

* The inventory table represents the latest inventory snapshot rather than historical inventory by date.
* Inventory coverage is estimated using recent average daily demand and assumes demand remains relatively stable.
* Products with inventory coverage below **7 days** are considered at risk of stockout.
* Target inventory is based on maintaining **30 days of inventory coverage** for each product.
* Potential revenue loss assumes customer demand cannot be fulfilled when inventory coverage falls below the minimum threshold.
* Excess inventory value represents the estimated capital tied up in inventory exceeding the 30-day target level.
* Revenue and profit calculations exclude discounts, product returns, and promotional adjustments because these data are unavailable in the dataset.
