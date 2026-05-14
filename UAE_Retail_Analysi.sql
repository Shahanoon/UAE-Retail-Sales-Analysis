CREATE TABLE uae_retail_sales (
    invoice_id VARCHAR(50) PRIMARY KEY,
    branch VARCHAR(50),
    city VARCHAR(50),
    customer_type VARCHAR(50),
    gender VARCHAR(20),
    product_line VARCHAR(100),
    unit_price DECIMAL(10, 2),
    quantity INT,
    vat_5_pct DECIMAL(10, 4),
    total_sales DECIMAL(10, 4),
    date_sold DATE,
    time_sold TIME,
    payment_method VARCHAR(50),
    cogs DECIMAL(10, 2),
    gross_margin_pct DECIMAL(10, 4),
    gross_income DECIMAL(10, 4),
    rating DECIMAL(3, 1)
);

--STEP 1
--1. Which Product Category is the most profitable?
--This helps the business decide which stock to increase.

SELECT product_line, 
       ROUND(SUM(total_sales), 2) AS total_revenue,
       ROUND(SUM(gross_income), 2) AS total_profit
FROM uae_retail_sales
GROUP BY product_line
ORDER BY total_profit DESC;


--2. Which Branch is performing poorly?
--Identify which city needs a new marketing campaign.

SELECT branch, city, 
       ROUND(SUM(total_sales), 2) AS total_revenue,
       COUNT(invoice_id) AS total_transactions,
       ROUND(AVG(rating), 1) AS avg_customer_rating
FROM uae_retail_sales
GROUP BY branch, city
ORDER BY total_revenue ASC;


/*3. What is the Average Basket Value (ABV)?
This tells you how much the average customer spends per visit in the UAE */

SELECT ROUND(AVG(total_sales), 2) AS avg_basket_value
FROM uae_retail_sales;


/*4. Customer Segmentation: Members vs. Normal
In the UAE, loyalty programs (like Majid Al Futtaim’s "SHARE" or Alshaya's "Aura") are huge. Let’s see if members spend more.*/

SELECT customer_type, 
       COUNT(*) AS total_customers,
       ROUND(SUM(total_sales), 2) AS total_revenue,
       ROUND(AVG(total_sales), 2) AS avg_spend_per_customer
FROM uae_retail_sales
GROUP BY customer_type;


--Run this block to see which products are your "Profit Leaders":

SELECT product_line, 
       ROUND(SUM(total_sales), 2) AS total_revenue,
       ROUND(SUM(gross_income), 2) AS total_profit
FROM uae_retail_sales
GROUP BY product_line
ORDER BY total_profit DESC;


--Then run this to see the performance of Dubai vs. Abu Dhabi vs. Sharjah

SELECT branch, city, 
       ROUND(SUM(total_sales), 2) AS total_revenue,
       COUNT(invoice_id) AS total_transactions,
       ROUND(AVG(rating), 1) AS avg_customer_rating
FROM uae_retail_sales
GROUP BY branch, city
ORDER BY total_revenue DESC;


CREATE TABLE dim_date AS
SELECT DISTINCT 
    date_sold,
    EXTRACT(YEAR FROM date_sold) AS year,
    EXTRACT(MONTH FROM date_sold) AS month,
    TO_CHAR(date_sold, 'Month') AS month_name,
    TO_CHAR(date_sold, 'Day') AS day_name,
    EXTRACT(DOW FROM date_sold) AS day_of_week
FROM uae_retail_sales;

--STEP 2

-- 1. Create a Branch Dimension Table
CREATE TABLE dim_branch AS
SELECT DISTINCT branch, city FROM uae_retail_sales;

-- 2. Create a Product Dimension Table
CREATE TABLE dim_product AS
SELECT DISTINCT product_line FROM uae_retail_sales;

-- 3. Create a Customer Dimension Table
CREATE TABLE dim_customer AS
SELECT DISTINCT customer_type, gender FROM uae_retail_sales;