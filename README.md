# Retail-Sales-Inventory-Optimization-Analysis

## 1. Project Background

### 1.1 Business Context

Maven Toys is a toy retailer operating multiple stores across different locations. Management wants to understand the drivers behind sales performance, identify opportunities to improve profitability, and ensure inventory levels are aligned with customer demand.
As the company approaches the holiday season, understanding sales trends, product performance, and inventory readiness becomes increasingly important to support business growth and reduce operational risks.

### 1.2 Business Questions

This analysis aims to answer the following questions:
1.	Are there recurring sales patterns or seasonality trends throughout the year?
2.	Which categories and products contribute the most to revenue and profit?
3.	Is the business overly dependent on specific products for sales performance?
4.	Are there products with strong profit potential that are currently underutilized?
5.	Which emerging products could become future growth drivers?
6.	Is inventory distributed efficiently across stores based on demand?
7.	What actions can be taken to improve profitability and inventory management before peak sales periods?

## 2. Data Preparation & Data Structure

![ETL Workflows](https://github.com/rifatz-the-analyst/Retail-Sales-Inventory-Optimization-Analysis/blob/dfdb677b2ecd898857615f552aa427288774820f/ETL%20Workflows.png)

### 2.1 Data Sources

The analysis uses five datasets:
- Sales transactions
- Product information
- Store information
- Inventory records
- Calendar table

### 2.2 Data Cleaning & Preparation

The following preparation steps were performed:
- Checked for missing and duplicate records.
- Standardized data format and store naming conventions.
- Validated transaction and inventory quantities.
- Validated and standardized product cost and product price
- Established relationships between sales, products, stores, inventory, and date tables.
- Created business metrics using DAX measures.

### 2.3 Key Metrics Created

- Revenue
- Profit
- Orders
- Average Order Value (AOV)
- Revenue Growth %
- Profit Growth %

### 2.4 Data Model

A star schema was developed to support efficient reporting and analysis.

Fact Tables:
- Sales
- Inventory
  
Dimension Tables:
- Products
- Stores
- Calendar



## 3. Executive Summary

- The analysis reveals that Maven Toys exhibits clear signs of seasonal demand, with sales peaks occurring during spring and year-end holiday periods. Sales performance in 2023 outperformed the same period in 2022, supported primarily by higher transaction volume.
- The Toys category remains the largest revenue contributor, generating 35.25% of total sales. However, nearly half of category revenue comes from a single product, Lego Bricks, creating a concentration risk for overall business performance.
- While high-revenue products dominate sales, several higher-margin products contribute disproportionately to profit. This suggests opportunities to improve profitability through more targeted product promotion.
- The Electronics category generates significantly more profit relative to its revenue contribution, while products such as Magic Sand demonstrate promising growth potential and may help diversify future revenue streams.
- Inventory analysis also reveals mismatches between stock allocation and demand patterns. Several top-selling products have less than seven days of inventory coverage, while slower-moving products remain overstocked in certain stores. These issues become particularly important as the business approaches the Q4 holiday season.

## Deep Analysis

### 4.1 Seasonal Sales Performance

Sales trends show recurring peaks during Q2 and Q4 of 2022. A similar increase was observed during Q2 of 2023, suggesting potential seasonality in customer demand.

These peaks likely correspond with:
- Spring purchasing activity
- Christmas and New Year holiday demand

Monthly sales performance in 2023 consistently exceeded the same period in 2022. Revenue growth closely followed increases in transaction volume, suggesting that stronger sales were driven primarily by higher order counts rather than changes in spending behavior.

Although the pattern appears consistent, additional historical data would be required to confirm long-term seasonality.

### 4.2 Revenue Concentration Risk

The Toys category contributes 35.25% of total revenue, making it the company's largest revenue driver.
Within the category, Lego Bricks account for 46.89% of category sales.

Trend analysis shows that fluctuations in Lego Bricks sales closely mirror fluctuations in overall company revenue. This indicates that business performance is heavily influenced by a single product, increasing vulnerability to demand changes, competitive pressure, or supply chain disruptions affecting that product.

### 4.3 Revenue vs Profit Performance

Although Lego Bricks dominate revenue generation, they are not the largest profit contributor within the Toys category.

Action Figures contribute:
- 32.21% of category profit
- Compared to 27.67% from Lego Bricks

A similar pattern appears across other categories, where the products generating the highest profits are not necessarily the highest-selling products.

This suggests that current sales performance is driven more by high-volume products than by products generating the strongest margins.

### 4.4 Electronics Category Performance

The Electronics category contributes:
- 15.55% of revenue
- 24.95% of profit

This makes Electronics one of the most profitable categories in the business.
Colorbuds dominate category performance:
- 69.64% of Electronics revenue
- 53.33% of Electronics profit

Additionally, Colorbuds contribute 20.80% of total company profit, making them the single largest profit contributor across all products.
However, Colorbuds sales have steadily declined between January 2022 and September 2023. This trend may indicate weakening demand and warrants further investigation to identify potential causes such as changing customer preferences, increased competition, or product lifecycle effects.

### 4.5 Emerging Growth Opportunity

Sales analysis identified strong growth within the Art & Crafts category, particularly for Magic Sand.

Beginning in Q4 2022, Magic Sand experienced sustained revenue growth and increased contribution to category performance. In 14 months, Magic Sand's revenue increased from $80 to $72,368 (a cumulative growth of 90,360%) with a compound monthly growth rate of 63.6%.

This trend suggests that Magic Sand could become a future growth driver and may help reduce the company's dependence on Lego Bricks as its primary revenue source.

### 4.6 Inventory Optimization Analysis

Inventory analysis reveals a mismatch between stock levels and actual demand across stores.

Key findings include:
- Many top-selling products have fewer than 7 days of inventory coverage.
- Several lower-demand products have more than 30 days of inventory coverage.
- Some products are completely out of stock in certain stores.

These conditions create two business risks:
- Lost sales opportunities from stockouts on high-demand and low-stocks products.
- Increased holding costs from excess inventory on slower-moving products, especially on low-demand and high-stocks products.

With Q4 approaching and historical data suggesting stronger seasonal demand, inventory allocation becomes increasingly important to maintain product availability and support revenue growth.

## Recommendations

### Recommendation 1: Increase Visibility of High-Margin Products

**Finding**

Across multiple categories, the products generating the highest profit are not the products generating the highest sales. For example, Action Figures contribute 32.21% of profit within the Toys category despite generating a smaller share of revenue than Lego Bricks.

**Recommendation**

Prioritize high-margin products in promotions, product placement, and cross-selling campaigns. Testing targeted campaigns for Action Figures and other category-level profit leaders could help improve profit performance without relying solely on additional sales volume.

**Expected Impact**

- Increase profit generated per transaction.
- Improve overall profit margins.
- Reduce dependence on high-revenue but lower-margin products.

### Recommendation 2: Reduce Revenue Dependence on Lego Bricks

**Finding**

The Toys category contributes 35.25% of total revenue, and Lego Bricks account for 46.89% of category sales. Overall revenue trends closely follow Lego Bricks performance, indicating concentration risk.

**Recommendation**

Invest in promotional campaigns for emerging products such as Magic Sand and other growing products to diversify the revenue mix. Product bundles and seasonal promotions could help increase adoption of alternative products.

**Expected Impact**

- Reduce revenue concentration risk.
- Create additional growth drivers beyond Lego Bricks.
- Improve long-term revenue stability if demand for Lego Bricks declines.

### Recommendation 3: Investigate the Decline in Colorbuds Sales

**Finding**

Colorbuds contribute 20.80% of total company profit and over half of Electronics profit, yet sales have steadily declined since January 2022.

**Recommendation**

Conduct additional analysis on Colorbuds performance, including store-level trends, pricing, and customer purchasing patterns. Because Colorbuds represent a significant portion of company profit, understanding the cause of the decline should be prioritized before implementing corrective actions.

**Expected Impact**

- Protect one of the company's largest profit streams.
- Identify opportunities to recover declining sales.
- Prevent further erosion of category profitability.

### Recommendation 4: Reallocate Inventory Before Peak Season

**Finding**

Many top-selling products have fewer than 7 days of inventory coverage, while some slower-moving products exceed 30 days of coverage. Several stores also have products that are already out of stock.

**Recommendation**

Reallocate inventory from overstocked products and stores to locations where high-demand products face stockout risk. Inventory planning should focus on products with strong daily demand ahead of the expected Q4 sales increase.

**Expected Impact**

- Reduce lost sales from stockouts.
- Improve inventory utilization across stores.
- Better support expected seasonal demand during Q4.

### Recommendation 5: Build a Demand-Based Inventory Monitoring Process

**Finding**

Current stock levels are not consistently aligned with product demand, resulting in both stockout and overstock situations.

**Recommendation**

Implement a simple inventory monitoring framework using inventory coverage days and average daily sales as key metrics. Products with coverage below 7 days can be flagged as "Reorder Risk," while products exceeding 30 days can be flagged as "Overstock Risk."

**Expected Impact**

- Improve inventory planning decisions.
- Reduce excess inventory costs.
- Increase product availability for customers.
