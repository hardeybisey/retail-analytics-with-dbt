# 📊 Retail Intelligence Analytics User Stories & Technical Solutions
---

## 🧍‍♂️ 1. Customer Analytics

**Q1: Track Monthly Active Customers by City**
- **User Story**: As a growth manager, I want to track the number of active customers by region over time to assess marketing campaign effectiveness.
- **Tables**: `dim_customer`, `dim_geolocation`, `dim_date`, `fact_orders`
- **Logic**:
  - Count distinct active customers per region and time period.

**Q2: Calculate Retention by Cohort**
- **User Story**: As a CRM analyst, I want to calculate retention rates for customer cohorts to measure engagement.
- **Tables**: `dim_customer`, `fact_orders`, `dim_date`
- **Logic**:
  - Define cohorts by customers’ signup date (using `dim_customer` or inferred from first order date in `fact_orders`).
  - Track repeat orders across subsequent time periods using `dim_date`.
  - Calculate retention as percentage of cohort ordering again.

**Q3: AOV by Segment**
- **User Story**: As a business analyst, I want to analyse average order value across customer segments to drive personalisation.
- **Tables**: `fact_orders`, `dim_customer`
- **Logic**:
  - Aggregate order totals from `fact_orders`.
  - Join with `dim_customer` to segment by region, customer tier, or other demographic.
  - Compute average order value per segment.

**Q4: Top Products per Loyalty Tier**
- **Tables**: `fact_order_items`, `fact_orders`, `dim_customer`, `dim_product`
- **Logic**:
  - Join `fact_order_items` with `fact_orders` to get `customer_key`.
  - Join to `dim_customer` for loyalty tier info.
  - Aggregate product purchase counts by tier.
  - Rank products per tier by frequency.

**Q5: RFM Segmentation**
- **Tables**: `fact_orders`
- **Logic**:
  - For each `customer_key` calculate:
    - Recency = days since last order (using `dim_date`).
    - Frequency = count of orders in a period.
    - Monetary = sum of order values.
  - Assign customers into RFM segments based on thresholds.

**Q6: Lifetime Value by Cohort**
- **Tables**: `fact_orders`, `dim_customer`, `dim_date`
- **Logic**:
  - Aggregate total revenue per customer over their lifetime.
  - Group customers by cohort (signup or first order date).
  - Analyse trends in LTV across cohorts.

---

## 📦 2. Product Analytics

**Q1: Revenue per Unit**
- **User Story**: As a category manager, I want to identify products generating the most revenue per unit sold.
- **Tables**: `fact_order_items`, `dim_product`
- **Logic**:
  - Sum revenue (`price * quantity`) and units sold per product.
  - Compute revenue per unit = total revenue / total units.

**Q2: Category Conversion Rate**
- **Tables**: `fact_order_items`, `dim_product`, `dim_product_category`
- **Logic**:
  - Join product views (if tracked) with product categories.
  - Compare category-level product views to actual purchases (`fact_order_items`).
  - Calculate conversion rate = purchases / views per category.

**Q3: Review Sentiment Trend by Product**
- **Tables**: `dim_order_review`, `dim_product`
- **Logic**:
  - Join reviews with products.
  - Aggregate sentiment scores or star ratings by product and time period.

**Q4: Price Elasticity of Top SKUs**
- **Tables**: `fact_order_items`, `dim_product`, `dim_date`
- **Logic**:
  - Analyse sales volume and price changes over time per product.
  - Use regression to estimate elasticity.

**Q5: Product Bundle Frequency**
- **Tables**: `fact_order_items`
- **Logic**:
  - Use basket analysis on `order_key` grouped items to find frequent co-purchases.

**Q6: Polarised Products**
- **Tables**: `dim_order_review`
- **Logic**:
  - Identify products with high counts of both 1-star and 5-star reviews.
  - Use proportions or thresholds.

---

## 💳 3. Transactions & Sales

**Q1: Sales Trends by Region and Time**
- **Tables**: `fact_orders`, `dim_customer`, `dim_geolocation`, `dim_date`
- **Logic**:
  - Join orders to customers and customers to geolocation.
  - Aggregate revenue by region and time period.

**Q2: AOV Over Time**
- **Tables**: `fact_orders`, `dim_date`
- **Logic**:
  - Calculate average order value grouped by order date (day/month).

**Q3: First-time vs Repeat Purchase**
- **Tables**: `fact_orders`
- **Logic**:
  - Identify first order per customer (minimum order date).
  - Classify subsequent orders as repeat.

**Q4: Product Co-occurrence Matrix**
- **Tables**: `fact_order_items`
- **Logic**:
  - For each order, identify pairs of products purchased together.
  - Aggregate counts to build co-occurrence matrix.

**Q5: Inventory Shortage Detector**
- **Tables**: `dim_product`, `fact_order_items`
- **Logic**:
  - Compare inventory levels from `dim_product` to recent sales volume in `fact_order_items`.
  - Flag products with low inventory vs demand.

---

## ⭐ 5. Review & GenAI / LLM Analytics

**Q1: Average Review Rating by Product**
- **Tables**: `dim_order_review`, `dim_product`
- **Logic**:
  - Aggregate average star rating per product.

**Q2: Extract Common Themes from Reviews**
- **Tables**: `dim_order_review`
- **Logic**:
  - Apply topic modelling (e.g. LDA) on review comments.

**Q3: Auto-Summarise Reviews Using LLM**
- **Tables**: `dim_order_review`
- **Logic**:
  - Generate product-level review summaries with LLM integration.

**Q4: Review Classification by Intent**
- **Tables**: `dim_order_review`
- **Logic**:
  - Use ML classifiers or few-shot prompting to categorise reviews (complaints, praise, feature requests).

**Q5: Generate FAQ from Reviews (RAG)**
- **Tables**: `dim_order_review`
- **Logic**:
  - Use Retrieval-Augmented Generation on indexed reviews to respond to natural language queries.

---

## 🔁 6. Cross-Domain Strategy

**Q1: Correlate Campaigns with Long-Term LTV**
- **Tables**: `fact_orders`, `dim_customer`
- **Logic**:
  - Add campaign exposure flags (if available) on customers.
  - Compare LTV across exposed vs control groups.

**Q2: Conversion Dropoff After Product Views**
- **Tables**: *Dependent on web events data availability*
- **Logic**:
  - Analyse products with high view counts but low purchase rates.

**Q3: Recommend Products Based on Review Similarity**
- **Tables**: `dim_order_review`, `fact_order_items`
- **Logic**:
  - Compute embeddings for reviews.
  - Recommend products with similar review profiles using vector similarity.
