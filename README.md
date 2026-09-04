# Retail Sales & Inventory Optimization Analysis

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

### 2.1 Data Sources

The analysis uses five datasets, sourced from the **Mexico Toy Sales** dataset by [Maven Analytics](https://mavenanalytics.io/data-playground/mexico-toy-sales) (Public Domain license):

- Sales transactions
- Product information
- Store information
- Inventory records
- Calendar table

### 2.2 Data Cleaning & Preparation

**The following preparation steps were performed:**
- Checked for missing and duplicate records.
- Standardized data format and store naming conventions.
- Validated transaction and inventory quantities.
- Validated and standardized product cost and product price
- Established relationships between sales, products, stores, inventory, and date tables.
- Created business metrics using DAX measures.

**Transaction and Revenue Profile**

<p align="center">
<img width="800" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/7e2abfbcc7d98327c8d7dbbf7e5d7934689d9396/revenue%20distribution.png" />

The sales data contains approximately 829K transactions from January 2022 to September 2023. Transaction revenue is relatively concentrated around lower values, with a mean of $17.42 and a median of $15. The maximum transaction revenue is $880, indicating the presence of a small number of high-value transactions.

Using the IQR method, the upper bound for transaction revenue was calculated at $36.45. Approximately 10.84% of transactions exceed this threshold, suggesting that the revenue distribution is right-skewed. These higher-value transactions may be driven by products with higher prices or transactions involving multiple units.

The most frequent transaction revenue value is $16, accounting for 96,401 transactions (11.62%). Further investigation shows that 97.35% of these $16 transactions come from three products: Action Figure, Magic Sand, and Dart Gun, which belong to three different categories. Most $16 transactions are single-unit purchases, indicating that this concentration is primarily related to the pricing of these products rather than customers purchasing multiple units.

**Units per Transaction**

The average number of units per transaction is 1.32, while the median is 1 unit. The maximum transaction contains 30 units.

This indicates that most purchases consist of a single product, while a relatively small number of transactions contain multiple units. This pattern is consistent with the revenue distribution, where most transactions are relatively low-value and a smaller number generate substantially higher revenue.

**Initial Product-Level Observations**

The initial exploration also revealed several patterns that required deeper investigation:

- Toys is the largest revenue-contributing category, accounting for 35.25% of total revenue.
- Lego Bricks contributes 46.89% of Toys revenue, making it a major driver of the overall sales trend.
- Revenue and profit contributions do not always align. For example, Action Figures generate a higher share of Toys' profit than Lego Bricks despite having a lower revenue contribution.
- Magic Sand has shown notable sales growth since Q4 2022, making it a potential product for further investigation.
- Colorbuds contributes significantly to Electronics revenue and profit, but its sales have shown a declining trend over the analysis period.

These initial findings suggest that revenue performance may be highly influenced by a small number of products, while some lower-revenue products may provide stronger profit or growth opportunities.

Therefore, the next stage of the analysis focuses on revenue trends, product and category performance, profitability, and inventory allocation across stores.

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

<p align="center">
<img width="500" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/781187eb517602eb6d57e004f3bb84d8ad5d8e32/Data%20Model.png" />

### 2.5 Analytical Approach & Tools

This analysis was conducted using three tools, each serving a distinct purpose in the workflow:

- **MySQL** was used for data extraction, heavy-duty cleaning, and understanding the grain and relationships between tables (sales, products, stores, inventory, and calendar). It also supported initial exploration to validate data quality before deeper analysis.
- **Python** was used for exploratory data analysis (EDA) — data profiling, segmentation, and deep-dive investigation into specific patterns identified during initial exploration (e.g., transaction revenue distribution, outlier detection using the IQR method).
- **Power BI** was used for data modeling (star schema), visual EDA to validate and communicate patterns interactively, and building the final dashboard for stakeholder consumption.

This division of labor reflects a typical end-to-end analytics workflow: SQL for structured data preparation, Python for statistical/analytical depth, and Power BI for modeling and stakeholder-facing visualization.

## 3. Executive Summary

- The analysis reveals that Maven Toys exhibits clear signs of seasonal demand, with sales peaks occurring during spring and year-end holiday periods. Sales performance in 2023 outperformed the same period in 2022, supported primarily by higher transaction volume.
- The Toys category remains the largest revenue contributor, generating 35.25% of total sales. However, nearly half of category revenue comes from a single product, Lego Bricks, creating a concentration risk for overall business performance.
- While high-revenue products dominate sales, several higher-margin products contribute disproportionately to profit. This suggests opportunities to improve profitability through more targeted product promotion.
- The Electronics category generates significantly more profit relative to its revenue contribution, while products such as Magic Sand demonstrate promising growth potential and may help diversify future revenue streams.
- Inventory analysis also reveals mismatches between stock allocation and demand patterns. Several top-selling products have less than seven days of inventory coverage, while slower-moving products remain overstocked in certain stores. These issues become particularly important as the business approaches the Q4 holiday season.

## 4. Analysis and Insights

### Investigation Flow

The analysis followed an iterative, top-down investigative process rather than a fixed checklist:

1. **Started with revenue trend analysis** at the monthly level to understand overall growth patterns and identify potential seasonality.
2. **Broke down revenue by product category** to identify which categories drive overall performance — Toys emerged as the largest revenue contributor.
3. **Drilled into Toys at the product level**, which revealed Lego Bricks as the largest revenue contributor within the category.
4. **Cross-checked revenue against profit** at the product level within Toys — despite Lego Bricks leading in revenue, Action Figures contributed more to category profit, indicating a revenue-profit misalignment worth investigating further.
5. **Repeated the revenue-vs-profit check at the category level**, which revealed that while Toys leads in revenue, Electronics actually generates more profit relative to its size.
6. **Drilled into Electronics**, finding that Colorbuds dominates both revenue and profit within the category — and is in fact the single largest profit contributor across the entire business.
7. **Investigated the declining trend visible in the Electronics category chart**, tracing it back specifically to Colorbuds' declining performance.
8. **Reviewed other categories for emerging patterns**, identifying a sharp upward trend in Magic Sand (Arts & Crafts). This was confirmed quantitatively by calculating its Compound Monthly Growth Rate (CMGR).
9. **For inventory analysis**, a 3-month baseline (Jul–Sep 2023) was deliberately chosen to calculate average daily sales and coverage days per store — using the most recent quarter ensures the analysis reflects current demand patterns rather than being diluted by demand from earlier in the ~21-month dataset.

Each subsequent section in this Deep Analysis reflects a stage in this investigation.

### 4.1 Seasonal Sales Performance

<img width="1000" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/781187eb517602eb6d57e004f3bb84d8ad5d8e32/revenue%20trend.png" />

Sales trends show recurring peaks during Q2 and Q4 of 2022. A similar increase was observed during Q2 of 2023, suggesting potential seasonality in customer demand.

These peaks likely correspond with:
- Spring purchasing activity
- Christmas and New Year holiday demand

Monthly sales performance in 2023 consistently exceeded the same period in 2022. Revenue growth closely followed increases in transaction volume, suggesting that stronger sales were driven primarily by higher order counts rather than changes in spending behavior.

Although the pattern appears consistent, additional historical data would be required to confirm long-term seasonality.

### 4.2 Revenue Concentration Risk

<img width="1020" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/781187eb517602eb6d57e004f3bb84d8ad5d8e32/revenue%20vs%20profit.png" />

The Toys category contributes 35.25% of total revenue, making it the company's largest revenue driver. Within the category, Lego Bricks account for 46.89% of category sales.

Trend analysis shows that changes in Lego Bricks sales closely mirror changes in total company revenue. It supported by a moderate positive correlation (r = 0.55) and statistically significant (p-value = 0.95%) between monthly revenue from Lego Bricks and the company’s total revenue. Combined with the fact that the top 25% of products generate 61.81% of total revenue, this suggests that business performance is highly concentrated among a small number of products.

This indicates that business performance is heavily influenced by top products, increasing vulnerability to demand changes, competitive pressure, or supply chain disruptions affecting that product.

### 4.3 Revenue vs Profit Performance

Although Lego Bricks dominate revenue generation, they are not the largest profit contributor within the Toys category.

Action Figures contribute:

- 32.21% of category profit
- Compared to 27.67% from Lego Bricks

A similar pattern appears across other categories, where the products generating the highest profits are not necessarily the highest-selling products. Lego Bricks products generate the highest revenue because it is the most expensive ($40), with an average order value (AOV) of $49.75.

This suggests that current sales performance is driven more by high-volume products than by products generating the strongest margins.

### 4.4 Electronics Category Performance

<img width="1020" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/781187eb517602eb6d57e004f3bb84d8ad5d8e32/colorbuds.png" />

The Electronics category contributes:

- 15.55% of revenue
- 24.95% of profit

This makes Electronics one of the most profitable categories in the business.
Colorbuds dominate category performance:

- 69.64% of Electronics revenue
- 53.33% of Electronics profit

Additionally, Colorbuds contribute 20.80% ($834.944) of total company profit, making them the single largest profit contributor across all products. However, Colorbuds sales have steadily declined between January 2022 and September 2023. Between January 2022 and September 2023, Colorbuds profit declined by 68%, equivalent to a compound monthly decline rate of 5.54%. If this trend continues over the next three months, annual profit could decrease by an estimated $138,768 (The estimate assumes the historical compound monthly decline rate of 5.54% continues unchanged over the next three months).

This trend may indicate weakening demand and warrants further investigation to identify potential causes such as changing customer preferences, increased competition, or product lifecycle effects.

### 4.5 Emerging Growth Opportunity

<p align="center">
<img width="300" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/781187eb517602eb6d57e004f3bb84d8ad5d8e32/magic%20sand.png" />

Sales analysis identified strong growth within the Art & Crafts category, particularly for Magic Sand.

Beginning in Q4 2022, Magic Sand experienced sustained revenue growth and increased contribution to category performance. Revenue increased from just $80 in July 2022 to $72,368 by September 2023, with a compound monthly growth rate of 63.6%. Magic Sand also generates 35.8% of total revenue in the Arts & Crafts category (the highest), and ranks third in total revenue across all products.

This trend suggests that Magic Sand could become a future growth driver and may help reduce the company's dependence on Lego Bricks as its primary revenue source.

### 4.6 Inventory Optimization Analysis

<img width="1020" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/78996449b1c2badb4502a634c7c2f0f3687f0655/Inventory%20Coverage.png" />

To ensure the coverage-days calculation reflects current demand rather than being diluted by 21 months of historical fluctuation, average daily sales were calculated using a 3-month baseline (July–September 2023) — the most recent quarter available in the dataset.

Overall inventory analysis across all stores:

- The Mini Basketball Hoop has 234 units in stock and 2.55 units sold per day. Therefore, the coverage stock days are 91.61 days (highest). Ideally, inventory should be 76 units for 30 days, resulting in an excess of 163 units. Consequently, the excess inventory of Mini Basketball Hoops ties up approximately $1,422 in capital.
- The Dino Egg has 649 units in stock and 104.03 units sold per day. Therefore, the coverage stock days are 6.24 days (lowest). Ideally, inventory should be 729 units for 7 days. Consequently, the lack inventory of Mini Basketball Hoops makes approximately $800 potential revenue loss.

However, inventory analysis reveals a mismatch between stock levels and actual demand across stores. If we analyse every store inventory, some stores have risky and excessive products:

- Many top-selling products have fewer than 7 days of inventory coverage. Every single store has at least one product that inventory coverage days fewer than 7 days. Some products are completely out of stock in certain stores.
- Several lower-demand products have more than 30 days of inventory coverage. Top 5 product by coverage days in every single store are higher than 30 days.

These conditions create two business risks:

- Lost sales opportunities from stockouts on high-demand and low-stocks products. For example, the inventory analysis in Ciudad de Mexico 2 Store (highest average daily order). It has eight products with lowest coverage days that fewer than 7 days. Those products have $1,749 potential revenue loss. In addition, an analysis of opportunities across 50 stores shows that there are a total of 370 products have $30,646 potential revenue loss with $8,504 potential profit loss.
- Increased holding costs from excess inventory on slower-moving products, especially on low-demand and high-stocks products. For example, the inventory analysis in Morelia 1 Store (highest coverage days). It has twelve products with highest coverage days that more than 30 days. Those products have $1,511 excess inventory value. In addition, an analysis of opportunities across 50 stores shows that there are a total of 492 products have $63,488 excess inventory value.

With Q4 approaching and historical data suggesting stronger seasonal demand, inventory allocation becomes increasingly important to maintain product availability and support revenue growth.

## 5. Recommendations

### 5.1 Increase Visibility of High-Margin Products

- **Finding**

  Across multiple categories, the products generating the highest profit are not the products generating the highest sales. For example, Action Figures contribute 32.21% of profit within the Toys category despite generating a smaller share of revenue than Lego Bricks.

- **Recommendation**

  Prioritize high-margin products in promotions, product placement, and cross-selling campaigns. Testing targeted campaigns for Action Figures and other category-level profit leaders could help improve profit performance without relying solely on additional sales volume.

- **Expected Impact**
  
  - Increase profit generated per transaction.
  - Improve overall profit margins.
  - Reduce dependence on high-revenue but lower-margin products.

### 5.2 Reduce Revenue Dependence on Lego Bricks

- **Finding**

  The Toys category contributes 35.25% of total revenue, and Lego Bricks account for 46.89% of category sales. Overall revenue trends closely follow Lego Bricks performance, indicating concentration risk.

- **Recommendation**

  Invest in promotional campaigns for emerging products such as Magic Sand and other growing products to diversify the revenue mix. Product bundles and seasonal promotions could help increase adoption of alternative products.

- **Expected Impact**
  
  - Reduce revenue concentration risk.
  - Create additional growth drivers beyond Lego Bricks.
  - Improve long-term revenue stability if demand for Lego Bricks declines.

### 5.3 Investigate the Decline in Colorbuds Sales

- **Finding**

  Colorbuds contribute 20.80% of total company profit and over half of Electronics profit, yet sales have steadily declined since January 2022.

- **Recommendation**

  Conduct additional analysis on Colorbuds performance, including store-level trends, pricing, and customer purchasing patterns. Because Colorbuds represent a significant portion of company profit, understanding the cause of the decline should be prioritized before implementing corrective actions.

- **Expected Impact**

  - Protect one of the company's largest profit streams.
  - Identify opportunities to recover declining sales.
  - Prevent further erosion of category profitability.

### 5.4 Reallocate Inventory Before Peak Season

- **Finding**

  Many top-selling products have fewer than 7 days of inventory coverage, while some slower-moving products exceed 30 days of coverage. Several stores also have products that are already out of stock.

- **Recommendation**

  Reallocate inventory from overstocked products and stores to locations where high-demand products face stockout risk. Inventory planning should focus on products with strong daily demand ahead of the expected Q4 sales increase.

- **Expected Impact**

  - Reduce lost sales from stockouts.
  - Improve inventory utilization across stores.
  - Better support expected seasonal demand during Q4.

### 5.5 Build a Demand-Based Inventory Monitoring Process

- **Finding**

  Current stock levels are not consistently aligned with product demand, resulting in both stockout and overstock situations.

- **Recommendation**

  Implement a simple inventory monitoring framework using inventory coverage days and average daily sales as key metrics. Products with coverage below 7 days can be flagged as "Reorder Risk," while products exceeding 30 days can be flagged as "Overstock Risk."

- **Expected Impact**

  - Improve inventory planning decisions.
  - Reduce excess inventory costs.
  - Increase product availability for customers.

## 6. Limitations

- **Limited time range for seasonality analysis.** The dataset covers January 2022 to September 2023 (~21 months, less than two full years). While recurring peaks were observed around Q2 and Q4, this timeframe is not sufficient to confirm seasonality with statistical confidence — a longer historical range would be needed to distinguish genuine seasonal patterns from year-specific anomalies.
- **Inventory data reflects a single snapshot, not historical stock levels.** The inventory table only captures current stock on hand rather than monthly or periodic stock records. As a result, true inventory turnover (units sold relative to average inventory held over a matching period) could not be calculated. Coverage days were used instead as a proxy, based on recent average daily sales relative to current stock.

## Dashboard Preview
<img width="1020" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/781187eb517602eb6d57e004f3bb84d8ad5d8e32/Overview.png" />

<img width="1020" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/781187eb517602eb6d57e004f3bb84d8ad5d8e32/Product.png" />

<img width="1020" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/78996449b1c2badb4502a634c7c2f0f3687f0655/Inventory.png" />
