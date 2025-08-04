# 📊 Retail Intelligence Analytics User Stories & Technical Solutions
---

## 📊 VIEW 1: `order_customer_region_date.sql`

### Use Case: **Customer/Region-Level Order Analysis**

### ✅ Recommended Charts:

1. **Orders Over Time by Region**

   * **Chart**: Line chart or area chart
   * **X-axis**: `dd.date_day` or `dd.month`
   * **Series**: `dl.state` or `dl.city`
   * **Metric**: `COUNT(fo.order_id)` or `SUM(order_value)`

2. **Order Count by Loyalty Tier**

   * **Chart**: Bar chart or horizontal bar chart
   * **X-axis**: `dc.loyalty_tier`
   * **Metric**: `COUNT(fo.order_id)` or `AVG(order_value)`

3. **Choropleth: Orders or Revenue by State**

   * **Chart**: Map (if Superset or Looker supports UK/BR states)
   * **Location**: `dl.state`
   * **Metric**: `SUM(order_value)` or `COUNT(order_id)`

4. **Customer LTV Distribution by Region**

   * **Chart**: Box plot or histogram
   * **X-axis**: `dl.state`
   * **Metric**: `SUM(order_value) OVER (PARTITION BY dc.customer_key)`

5. **Cohort Retention Heatmap**

   * **Chart**: Heatmap
   * **X-axis**: `customer_signup_month`
   * **Y-axis**: `months_since_signup`
   * **Metric**: `retained_customers / total_customers`

---

## 📊 VIEW 2: `order_item_seller_product_region_date`

### Use Case: **Product/Seller-Level Performance Monitoring**

### ✅ Recommended Charts:

1. **Top Selling Products by Category**

   * **Chart**: Treemap or bar chart
   * **X-axis**: `dp.product_category_name`
   * **Metric**: `SUM(foi.item_price)` or `COUNT(foi.order_item_id)`

2. **Revenue Trend by Seller Region**

   * **Chart**: Line chart or stacked area chart
   * **X-axis**: `dd.month`
   * **Series**: `dr.state` or `dr.city`
   * **Metric**: `SUM(foi.item_price + foi.freight_price)`

3. **Freight Cost Share by Product Category**

   * **Chart**: Stacked bar or pie chart
   * **Categories**: `dp.product_category_name`
   * **Metric**: `SUM(foi.freight_price) / SUM(foi.item_price + foi.freight_price)`

4. **Product Price vs Freight Cost**

   * **Chart**: Scatter plot
   * **X-axis**: `AVG(foi.item_price)`
   * **Y-axis**: `AVG(foi.freight_price)`
   * **Size**: `COUNT(foi.order_item_id)`
   * **Colour**: `dp.product_category_name`

5. **Seller Performance Heatmap**

   * **Chart**: Heatmap
   * **X-axis**: `ds.seller_id`
   * **Y-axis**: `dd.week`
   * **Metric**: `SUM(foi.item_price + foi.freight_price)`
