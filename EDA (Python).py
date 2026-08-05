import pandas as pd
import math

#read table from CSV
df_products  = pd.read_csv("products.csv")
df_stores = pd.read_csv("stores.csv")
df_sales = pd.read_csv("sales.csv")
df_inventory = pd.read_csv("inventory.csv")
df_calendar = pd.read_csv("calendar.csv")

#data merging and formating
products_subset = df_products[['product_id', 'product_category', 'product_name']]
analysis_table = df_sales.merge(products_subset,how="inner", on="product_id")
analysis_table = analysis_table.merge(df_stores,how="inner", on="store_id")
analysis_table["date"] = pd.to_datetime(analysis_table["date"])

#feature engineer
analysis_table["profit"] = analysis_table["revenue"] - analysis_table["cogs"]
analysis_table["year"] = analysis_table["date"].dt.year
analysis_table["month"] = analysis_table["date"].dt.month

#monthly total revenue and profit
revenue_by_month = analysis_table.groupby(["year","month"])["revenue"].sum()
revenue_monthly_growth = revenue_by_month.pct_change()*100
profit_by_month = analysis_table.groupby(["year","month"])["profit"].sum()

#category performance
category_performance = (
    analysis_table.groupby("product_category")
    .agg(
        total_revenue=("revenue","sum"),
        total_profit=("profit","sum")
    )
)
category_total_revenue = category_performance["total_revenue"].sum()
category_performance["revenue_contribution"] = category_performance["total_revenue"]/category_total_revenue*100
category_total_profit = category_performance["total_profit"].sum()
category_performance["profit_contribution"] = category_performance["total_profit"]/category_total_profit*100

#product performance for each category
product_performance_in_category = (
    analysis_table
    .groupby(["product_category","product_name"])[["revenue","profit"]]
    .sum()
).reset_index()

category_total_metrics = (
    product_performance_in_category
    .groupby("product_category")[["revenue","profit"]]
    .transform("sum")
)

product_performance_in_category[["category_revenue","category_profit"]] = category_total_metrics
product_performance_in_category["revenue_contribution"] = (
    product_performance_in_category["revenue"]/product_performance_in_category["category_revenue"]*100
)

product_performance_in_category["profit_contribution"] = (
    product_performance_in_category["profit"]/product_performance_in_category["category_profit"]*100
)

summary_product_in_category = (
    product_performance_in_category
    [["product_category","product_name","revenue_contribution","profit_contribution"]]
)

#product performance
product_performance = (
    analysis_table.groupby("product_name")
    .agg(
        total_revenue=("revenue","sum"),
        total_profit=("profit","sum")
    )
)
product_total_revenue = product_performance["total_revenue"].sum()
product_performance["revenue_contribution"] = product_performance["total_revenue"]/product_total_revenue*100
product_total_profit = product_performance["total_profit"].sum()
product_performance["profit_contribution"] = product_performance["total_profit"]/product_total_profit*100

product_performance = product_performance.sort_values("revenue_contribution",ascending=False)

monthly_product_performance = analysis_table.pivot_table(
    index=["year","month"],
    columns="product_name",
    values="revenue",
    aggfunc="sum"
)
monthly_product_growth = monthly_product_performance.pct_change()*100

#correlation of monthly total revenue and monthly total revenue of highest product
monthly_revenue = revenue_by_month.reset_index()
monthly_revenue_product = monthly_product_performance.reset_index()
correlation = monthly_revenue["revenue"].corr(monthly_revenue_product["Lego Bricks"])

#calculate the compound monthly growth rate (CMGR)
def cmgr(series):
    valid_value = series.dropna()

    if len(valid_value) < 2:
        return None

    first_value = valid_value.iloc[0]
    last_value = valid_value.iloc[-1]

    first_pos = series.index.get_loc(valid_value.index[0])
    last_pos = series.index.get_loc(valid_value.index[-1])
    n = last_pos - first_pos

    if n == 0 or first_value <= 0:
        return None

    cmgr = (last_value/first_value)**(1/n)-1
    return cmgr*100

#CMGR by product
product_cmgr = monthly_product_performance.apply(cmgr)
month_with_revenue = monthly_product_performance.count()
summary_cmgr = pd.DataFrame({
    "cmgr" : product_cmgr,
    "active_month" : month_with_revenue
}).sort_values("cmgr",ascending=False)

#counting the number of days in last 3 months
last_three_month = (
    df_calendar[
        df_calendar["dates"]
        .between("2023-07-01","2023-09-30")
    ]
)
days_count = last_three_month["dates"].count()

#table data for last three months
last_three_month_data = (
    analysis_table[
        analysis_table["date"]
        .between("2023-07-01","2023-09-30")
    ]
)

#data merging and formating for inventory analysis
pivot_analysis = last_three_month_data.pivot_table(
    index=["store_id", "product_id"],
    values="units",
    aggfunc="sum"
).reset_index()

inventory_analysis = df_inventory.merge(
    pivot_analysis,
    how="left",
    on=["store_id","product_id"]
)

inventory_analysis = inventory_analysis.merge(
    df_products[["product_id","product_name"]],
    how="left",
    on="product_id"
).merge(
    df_stores[["store_id","store_name"]],
    how="left",
    on="store_id"
)

#feature engineering
inventory_analysis["avg_daily_sales"] = inventory_analysis["units"]/days_count
inventory_analysis["coverage_days"] = inventory_analysis["stock_on_hand"]/inventory_analysis["avg_daily_sales"]

#inventory calculation and categorization
def inventory_status(x):
  stock = x["stock_on_hand"]
  avg_units = x["avg_daily_sales"]

  if pd.isna(stock) or pd.isna(avg_units):
        return "No Data"
  if stock == 0 and avg_units == 0:
        return "No Stock & No Sales"
  if avg_units == 0:
        return "Over Stock"
  
  coverage = stock/avg_units
  if coverage <= 7:
    return "Low Stock"
  elif coverage <= 30:
    return "Healthy"
  else:
    return "Over Stock"

inventory_analysis["inventory_status"] = inventory_analysis.apply(inventory_status, axis=1)

#create table for opportunity analysis
products_subset = df_products[["product_id","product_cost","product_price"]]
opportunity_table = inventory_analysis.merge(products_subset, how="left", on="product_id")

#create table for excess value analysis
excess_table = opportunity_table[
    opportunity_table["inventory_status"]=="Over Stock"
]

excess_table = excess_table[[
    "store_id","product_id","stock_on_hand","units","avg_daily_sales","product_cost"
]]

excess_table["max_stock"] = (excess_table["avg_daily_sales"] * 30).apply(math.floor)
excess_table["excess_stock"] = excess_table["stock_on_hand"] - excess_table["max_stock"]

excess_table["excess_value"] = excess_table["excess_stock"] * excess_table["product_cost"]

#create table for loss opportunity analysis
loss_table = opportunity_table[
    opportunity_table["inventory_status"]=="Low Stock"
]
loss_table = loss_table[[
    "store_id","product_id","coverage_days","units","avg_daily_sales","product_price","product_cost"
]]

loss_table["daily_revenue"] = loss_table["avg_daily_sales"] * loss_table["product_price"]
loss_table["daily_profit"] = (loss_table["avg_daily_sales"] * loss_table["product_price"]) - (loss_table["avg_daily_sales"] * loss_table["product_cost"])
loss_table["loss_days"] = 7 - loss_table["coverage_days"]

loss_table["loss_revenue"] = loss_table["loss_days"] * loss_table["daily_revenue"]
loss_table["loss_profit"] = loss_table["loss_days"] * loss_table["daily_profit"]