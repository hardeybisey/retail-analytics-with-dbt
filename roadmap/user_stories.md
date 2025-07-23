# 📊 Retail Intelligence Analytics User Stories & Technical Solutions

## 🧍‍♂️ 1. Customer Analytics

**Q1: Track Active Customers by Region and Time**
- **User Story**: As a growth manager, I want to track the number of active customers by region over time so I can assess marketing campaign effectiveness.
- **Tables**: `customers`
- **Logic**: Group customers by region and signup month; count distinct customers.

**Q2: Calculate Retention by Cohort**
- **User Story**: As a CRM analyst, I want to calculate retention rates for customer cohorts so I can measure engagement.
- **Tables**: `customers`, `transactions`
- **Logic**: Create customer cohorts by signup month; track activity across future periods.

**Q3: AOV by Segment**
- **User Story**: As a business analyst, I want to analyse AOV across customer segments to drive personalisation.
- **Tables**: `transactions`, `customers`
- **Logic**: Calculate average order value per segment (e.g., region or tier).

**Q4: Top Products per Loyalty Tier**
- **Tables**: `transactions`, `customers`, `products`
- **Logic**: Join transactions with customer tier; rank most frequently purchased products.

**Q5: RFM Segmentation**
- **Tables**: `transactions`
- **Logic**: Calculate Recency, Frequency, and Monetary values per customer and assign segment labels.

**Q6: Lifetime Value by Cohort**
- **Tables**: `transactions`, `customers`
- **Logic**: Sum total revenue per customer across time; group by cohort for trend analysis.

---

## 📦 2. Product Analytics

**Q1: Revenue per Unit**
- **User Story**: As a category manager, I want to see products generating the most revenue per unit sold.
- **Tables**: `transactions`, `products`
- **Logic**: Aggregate revenue and units sold; compute ratio.

**Q2: Category Conversion Rate**
- **Tables**: `web_events`, `transactions`, `products`
- **Logic**: Compare product views with purchases at the category level.

**Q3: Review Sentiment Trend by Product**
- **Tables**: `product_reviews`
- **Logic**: Generate sentiment scores; group by product and time.

**Q4: Price Elasticity of Top SKUs**
- **Tables**: `transactions`, `products`
- **Logic**: Measure impact of price changes on sales volume using regression.

**Q5: Product Bundle Frequency**
- **Tables**: `transactions`
- **Logic**: Identify co-purchased products using basket analysis.

**Q6: Polarised Products**
- **Tables**: `product_reviews`
- **Logic**: Identify products with high proportions of both 1★ and 5★ reviews.

---

## 💳 3. Transactions & Sales

**Q1: Sales Trends by Region and Time**
- **Tables**: `transactions`, `customers`
- **Logic**: Aggregate revenue over time per region.

**Q2: AOV Over Time**
- **Tables**: `transactions`
- **Logic**: Calculate average order value per time period.

**Q3: First-time vs Repeat Purchase**
- **Tables**: `transactions`
- **Logic**: Use ordering to classify first vs repeat purchases per customer.

**Q4: Product Co-occurrence Matrix**
- **Tables**: `transactions`
- **Logic**: Determine which products are purchased together in the same order.

**Q5: Inventory Shortage Detector**
- **Tables**: `products`, `transactions`
- **Logic**: Compare inventory levels to recent sales trends.

---

## 🌐 4. Web Events & Funnel Analytics

**Q1: Navigation Paths to Purchase**
- **Tables**: `web_events`, `transactions`
- **Logic**: Track session events and identify conversion paths.

**Q2: Funnel Drop-off Rates**
- **Tables**: `web_events`
- **Logic**: Count session events by step (view → cart → purchase); compute drop-off rates.

**Q3: Device CTR Comparison**
- **Tables**: `web_events`
- **Logic**: Compare click-through rates across device types.

**Q4: Predict Purchase Intent from Sessions**
- **Tables**: `web_events`
- **Logic**: Feature engineer session behaviours; train ML model to predict purchase.

---

## ⭐ 5. Review & GenAI / LLM Analytics

**Q1: Average Review Rating by Product**
- **Tables**: `product_reviews`
- **Logic**: Aggregate ratings grouped by product.

**Q2: Extract Common Themes from Reviews**
- **Tables**: `product_reviews`
- **Logic**: Apply topic modelling to review text.

**Q3: Auto-Summarise Reviews Using LLM**
- **Tables**: `product_reviews`
- **Logic**: Generate summary text using LLM per product.

**Q4: Review Classification by Intent**
- **Tables**: `product_reviews`
- **Logic**: Categorise review purpose (complaint, praise, etc.) using zero/few-shot classification.

**Q5: Generate FAQ from Reviews (RAG)**
- **Tables**: `product_reviews`
- **Logic**: Index reviews for similarity search and respond to natural language queries.

---

## 🔁 6. Cross-Domain Strategy

**Q1: Correlate Campaigns with Long-Term LTV**
- **Tables**: `web_events`, `transactions`, `customers`
- **Logic**: Compare cohorts exposed to campaigns vs control on LTV outcomes.

**Q2: Conversion Dropoff After Product Views**
- **Tables**: `web_events`, `transactions`, `products`
- **Logic**: Identify products with high views but low purchases.

**Q3: Recommend Products Based on Review Similarity**
- **Tables**: `product_reviews`, `transactions`
- **Logic**: Compute text embeddings for reviews; recommend similar items based on vector similarity.
