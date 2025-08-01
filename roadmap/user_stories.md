# 📊 Retail Intelligence Analytics User Stories & Technical Solutions
---

Given your queries are joining fact tables with rich dimensional attributes (customer, region, seller, product, date), you're primed for **exploratory and performance-monitoring dashboards**. Below is a breakdown of **high-impact charts** you can generate from each query.

---

## 📊 From Query 1: `fact_orders` + `dim_customer` + `dim_region` + `dim_date`

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

## 📊 From Query 2: `fact_order_items` + `dim_product` + `dim_seller` + `dim_region` + `dim_date`

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

---

## 🧠 Tool-Specific Notes

If you're using **Superset**:

* Use **time grain** and **filters** in the Explore interface to group by week/month.
* For maps, ensure `region` or `zip_code` matches the format expected by your geospatial layer.

If you're using **Looker**, **Power BI**, or **Tableau**, you can use **LOD expressions** or **table calcs** to create metrics like LTV, AOV, etc., and **parameter controls** for slicing by seller/product/region.

---

**Follow Up:**
**Would you like a dashboard wireframe that arranges these charts into a layout designed for e-commerce ops, finance, or growth teams?**
