/*
===============================================================================
E-COMMERCE SALES ANALYTICS
SQL QUERY SUMMARY & PATTERN REFERENCE
===============================================================================

Purpose:
    Quick reference for SQL concepts, patterns, and business-analysis
    techniques practiced throughout this project.

Dataset:
    Ecommerce Sales Analytics

Query Progression:
    01_basic_queries.sql
    02_aggregate_functions.sql
    03_joins.sql
    04_subqueries.sql
    05_ctes.sql
    06_window_functions.sql
    07_business_questions.sql
    08_advanced_analysis.sql
    09_interview_questions.sql
    10_query_summary.sql

===============================================================================
*/


/*
===============================================================================
01. BASIC SELECT
===============================================================================

Use when:
    - Retrieving specific columns
    - Filtering rows
    - Sorting results
===============================================================================
*/

SELECT
    column1,
    column2
FROM table_name
WHERE condition
ORDER BY column1;


/*
===============================================================================
02. WHERE
===============================================================================

Use when:
    Filtering individual rows BEFORE aggregation.

Example:
    Find orders with a particular status.
===============================================================================
*/

SELECT
    order_id,
    order_status
FROM orders
WHERE order_status = 'delivered';


/*
===============================================================================
03. DISTINCT
===============================================================================

Use when:
    You need unique values.

Common example:
    Count unique customers or unique orders.
===============================================================================
*/

SELECT DISTINCT
    customer_state
FROM customers;


/*
===============================================================================
04. COUNT
===============================================================================

COUNT(*):
    Counts rows.

COUNT(column):
    Counts non-NULL values.

COUNT(DISTINCT column):
    Counts unique values.

Important:
    In ecommerce analysis, COUNT(DISTINCT order_id) is often required
    because an order can contain multiple order_items.
===============================================================================
*/

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_unique_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;


/*
===============================================================================
05. AGGREGATE FUNCTIONS
===============================================================================

Common aggregate functions:

    COUNT()
    COUNT(DISTINCT)
    SUM()
    AVG()
    MIN()
    MAX()

Pattern:

    SELECT
        grouping_column,
        AGGREGATE_FUNCTION(column)
    FROM table
    GROUP BY grouping_column;
===============================================================================
*/

SELECT
    customer_unique_id,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(price) AS total_spent,
    AVG(price) AS average_price
FROM ...
GROUP BY customer_unique_id;


/*
===============================================================================
06. GROUP BY
===============================================================================

Use when:
    Multiple rows need to be summarized into groups.

Think:

    Raw rows
        ↓
    GROUP BY
        ↓
    One row per group
        ↓
    Aggregate calculation

Examples:
    - Revenue by seller
    - Spending by customer
    - Revenue by category
    - Revenue by month
===============================================================================
*/

SELECT
    seller_id,
    SUM(price) AS total_revenue
FROM order_items
GROUP BY seller_id;


/*
===============================================================================
07. HAVING
===============================================================================

Use when:
    Filtering AFTER aggregation.

WHERE:
    Filters rows before GROUP BY.

HAVING:
    Filters groups after GROUP BY.
===============================================================================
*/

SELECT
    customer_unique_id,
    SUM(price) AS total_spent
FROM ...
GROUP BY customer_unique_id
HAVING SUM(price) > 1000;


/*
===============================================================================
08. INNER JOIN
===============================================================================

Use when:
    Only matching records from both tables are required.
===============================================================================
*/

SELECT
    c.customer_unique_id,
    o.order_id
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id;


/*
===============================================================================
09. LEFT JOIN
===============================================================================

Use when:
    All records from the LEFT table must be retained,
    even if there is no matching record in the RIGHT table.

Pattern:

    LEFT table
        ↓
    LEFT JOIN
        ↓
    Matching data from right table
===============================================================================
*/

SELECT
    c.customer_unique_id,
    o.order_id
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id;


/*
===============================================================================
10. MULTIPLE JOINS
===============================================================================

Common ecommerce relationship:

    customers
        ↓
    orders
        ↓
    order_items
        ↓
    products / sellers

Example:
===============================================================================
*/

SELECT
    c.customer_unique_id,
    o.order_id,
    oi.product_id,
    oi.price
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id;


/*
===============================================================================
11. SUBQUERY
===============================================================================

Use when:
    One query depends on the result of another query.

Common business question:

    Find customers whose spending is above the average customer spending.
===============================================================================
*/

SELECT
    customer_unique_id,
    total_spent
FROM customer_totals
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM customer_totals
);


/*
===============================================================================
12. CTE - COMMON TABLE EXPRESSION
===============================================================================

Use when:
    A query has multiple logical steps.

Benefits:
    - Improves readability
    - Breaks complex queries into steps
    - Makes business logic easier to understand
    - Useful before applying window functions

Pattern:

    WITH step_1 AS (...),
    step_2 AS (...)
    SELECT ...
    FROM step_2;
===============================================================================
*/

WITH customer_metrics AS
(
    SELECT
        ...
),

customer_ranking AS
(
    SELECT
        ...
    FROM customer_metrics
)

SELECT
    ...
FROM customer_ranking;


/*
===============================================================================
13. DATE_TRUNC
===============================================================================

Use when:
    Grouping timestamps into a time period.

Common examples:

    DATE_TRUNC('month', timestamp)
    DATE_TRUNC('year', timestamp)
    DATE_TRUNC('day', timestamp)

Most common in this project:

    Monthly revenue
    Monthly customer acquisition
    Monthly category revenue
===============================================================================
*/

SELECT
    DATE_TRUNC(
        'month',
        order_purchase_timestamp
    ) AS month,
    SUM(price) AS monthly_revenue
FROM ...
GROUP BY month;


/*
===============================================================================
14. DATE DIFFERENCE
===============================================================================

Used for:
    - Customer recency
    - Delivery days
    - Customer lifetime
    - Days between purchases
===============================================================================
*/

CURRENT_DATE - last_purchase_date;


/*
===============================================================================
15. MIN() AND MAX() FOR CUSTOMER LIFECYCLE
===============================================================================

MIN():
    First purchase

MAX():
    Last purchase

Useful for:
    - First purchase date
    - Last purchase date
    - Customer lifetime
    - Cohort analysis
===============================================================================
*/

SELECT
    customer_unique_id,
    MIN(order_purchase_timestamp) AS first_purchase_date,
    MAX(order_purchase_timestamp) AS last_purchase_date
FROM ...
GROUP BY customer_unique_id;


/*
===============================================================================
16. CASE
===============================================================================

Use when:
    Business rules need to convert numerical/data conditions into categories.

Example:
    Repeat vs One-Time Customer
===============================================================================
*/

CASE
    WHEN total_orders > 1
        THEN 'Repeat Customer'
    ELSE
        'One-Time Customer'
END AS customer_type;


/*
===============================================================================
17. RANK()
===============================================================================

Use when:
    Ranking values while allowing ties.

Example:

    1000 → 1
     900 → 2
     900 → 2
     800 → 4

Important:
    RANK() creates gaps after ties.
===============================================================================
*/

RANK() OVER(
    ORDER BY total_revenue DESC
);


/*
===============================================================================
18. DENSE_RANK()
===============================================================================

Use when:
    Ranking values while allowing ties WITHOUT gaps.

Example:

    1000 → 1
     900 → 2
     900 → 2
     800 → 3
===============================================================================
*/

DENSE_RANK() OVER(
    ORDER BY total_revenue DESC
);


/*
===============================================================================
19. ROW_NUMBER()
===============================================================================

Use when:
    Every row needs a unique sequential number.

Example:

    1000 → 1
     900 → 2
     900 → 3
     800 → 4

Unlike RANK and DENSE_RANK, ties do not receive the same number.
===============================================================================
*/

ROW_NUMBER() OVER(
    ORDER BY total_revenue DESC
);


/*
===============================================================================
20. RANK vs DENSE_RANK vs ROW_NUMBER
===============================================================================

Data:

    1000
     900
     900
     800

RANK():

    1
    2
    2
    4

DENSE_RANK():

    1
    2
    2
    3

ROW_NUMBER():

    1
    2
    3
    4

Remember:

    RANK       → ties + gaps
    DENSE_RANK → ties + no gaps
    ROW_NUMBER → unique position
===============================================================================
*/


/*
===============================================================================
21. PARTITION BY
===============================================================================

Use when:
    A window calculation needs to restart for each group.

Example:
    Rank sellers separately within each state.

Think:

    Without PARTITION BY:
        One global ranking.

    With PARTITION BY:
        Ranking restarts for every group.
===============================================================================
*/

RANK() OVER(
    PARTITION BY seller_state
    ORDER BY total_revenue DESC
);


/*
===============================================================================
22. RUNNING / CUMULATIVE TOTAL
===============================================================================

Use when:
    You need a cumulative value over time.

Pattern:
===============================================================================
*/

SUM(monthly_revenue) OVER(
    ORDER BY month
);


/*
===============================================================================
23. LAG()
===============================================================================

Use when:
    You need the previous row's value.

Common business questions:
    - Previous month revenue
    - Previous purchase
    - Revenue change
    - Month-over-month growth
===============================================================================
*/

LAG(monthly_revenue) OVER(
    ORDER BY month
);


/*
===============================================================================
24. LEAD()
===============================================================================

Use when:
    You need the next row's value.

Think:

    LAG  → Previous
    LEAD → Next
===============================================================================
*/

LEAD(monthly_revenue) OVER(
    ORDER BY month
);


/*
===============================================================================
25. MONTH-OVER-MONTH GROWTH
===============================================================================

Formula:

    Current Revenue - Previous Revenue
    ----------------------------------- × 100
            Previous Revenue

SQL pattern:
===============================================================================
*/

(
    (
        monthly_revenue -
        previous_month_revenue
    )
    /
    NULLIF(previous_month_revenue, 0)
) * 100;


/*
===============================================================================
26. REVENUE CHANGE
===============================================================================

Formula:

    Current Revenue - Previous Revenue
===============================================================================
*/

monthly_revenue - previous_month_revenue;


/*
===============================================================================
27. NULLIF()
===============================================================================

Use when:
    Division by zero is possible.

Pattern:
===============================================================================
*/

value / NULLIF(denominator, 0);


/*
===============================================================================
28. PERCENTAGE CONTRIBUTION
===============================================================================

General formula:

    Individual Value
    ---------------- × 100
      Total Value

Global contribution:
===============================================================================
*/

(
    category_revenue /
    SUM(category_revenue) OVER()
) * 100;


/*
===============================================================================
29. PERCENTAGE CONTRIBUTION WITHIN A GROUP
===============================================================================

Example:

    Category contribution to monthly revenue.

Important:

    PARTITION BY month

means the total is calculated separately for each month.
===============================================================================
*/

(
    category_revenue /
    SUM(category_revenue) OVER(
        PARTITION BY month
    )
) * 100;


/*
===============================================================================
30. NTILE()
===============================================================================

Use when:
    Dividing rows into approximately equal groups.

Example:

    NTILE(4)

creates four groups.

Useful for:
    - Quartiles
    - Customer spending segments
    - RFM analysis
===============================================================================
*/

NTILE(4) OVER(
    ORDER BY total_spent
);


/*
===============================================================================
31. OVER() WITHOUT PARTITION
===============================================================================

Important concept:

    AVG(total_spent) OVER()

calculates the average across ALL rows in the result set.

Example:

    Customer A → 100
    Customer B → 200
    Customer C → 300

Overall average → 200
===============================================================================
*/

AVG(total_spent) OVER();


/*
===============================================================================
32. PARTITION BY vs NO PARTITION
===============================================================================

NO PARTITION:

    AVG(total_spent) OVER()

    → Average across all customers.

WITH PARTITION:

    AVG(total_spent) OVER(
        PARTITION BY customer_state
    )

    → Average separately for every state.

Important mistake to avoid:

    AVG(total_spent) OVER(
        PARTITION BY customer_unique_id
    )

If there is one row per customer, this simply returns the customer's
own spending rather than the overall average.
===============================================================================
*/


/*
===============================================================================
33. TOP N PATTERN
===============================================================================

When a window function creates a rank, filter it in an outer query/CTE.

Pattern:
===============================================================================
*/

WITH ranked_data AS
(
    SELECT
        ...,
        DENSE_RANK() OVER(
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM ...
)

SELECT
    ...
FROM ranked_data
WHERE revenue_rank <= 10;


/*
===============================================================================
34. TOP N WITH TIES
===============================================================================

Use:

    DENSE_RANK()
    +
    WHERE rank <= N

Example:

    Top 3 products in every category.
===============================================================================
*/

WITH ranked_products AS
(
    SELECT
        product_id,
        product_category,
        total_revenue,

        DENSE_RANK() OVER(
            PARTITION BY product_category
            ORDER BY total_revenue DESC
        ) AS product_rank

    FROM product_revenue
)

SELECT
    *
FROM ranked_products
WHERE product_rank <= 3;


/*
===============================================================================
35. TOP N ROWS
===============================================================================

If the requirement specifically means exactly N rows:

    ORDER BY ...
    LIMIT N

Example:
===============================================================================
*/

SELECT
    *
FROM customer_totals
ORDER BY total_spent DESC
LIMIT 10;


/*
===============================================================================
36. CUSTOMER PURCHASE FREQUENCY
===============================================================================

Business question:

    How many orders has each customer placed?

Pattern:
===============================================================================
*/

COUNT(DISTINCT order_id);


/*
===============================================================================
37. REPEAT CUSTOMER
===============================================================================

Business rule:

    More than one order = Repeat Customer
===============================================================================
*/

CASE
    WHEN total_orders > 1
        THEN 'Repeat Customer'
    ELSE
        'One-Time Customer'
END AS customer_type;


/*
===============================================================================
38. CUSTOMER LIFETIME VALUE / VALUE METRICS
===============================================================================

Common customer metrics:

    Total Orders
    Total Spent
    Average Order Value

Average Order Value:

    Total Spent
    -----------
    Total Orders
===============================================================================
*/

total_spent / NULLIF(total_orders, 0);


/*
===============================================================================
39. CUSTOMER RECENCY
===============================================================================

Recency:

    Number of days since customer's latest purchase.

Pattern:
===============================================================================
*/

CURRENT_DATE - MAX(order_purchase_timestamp::date);


/*
===============================================================================
40. CUSTOMER COHORT
===============================================================================

Cohort month:

    Month in which the customer made their first purchase.

Pattern:

    MIN(purchase_date)
        ↓
    DATE_TRUNC('month', first_purchase_date)
===============================================================================
*/

DATE_TRUNC(
    'month',
    MIN(order_purchase_timestamp)
);


/*
===============================================================================
41. RFM ANALYSIS
===============================================================================

RFM:

    R = Recency
    F = Frequency
    M = Monetary

Recency:
    Days since last purchase.

Frequency:
    Number of orders.

Monetary:
    Total spending.

Typical scoring:

    NTILE(4)

Then:

    RFM Score =
        Recency Score
        +
        Frequency Score
        +
        Monetary Score
===============================================================================
*/

NTILE(4) OVER(
    ORDER BY recency ASC
) AS recency_score,

NTILE(4) OVER(
    ORDER BY frequency ASC
) AS frequency_score,

NTILE(4) OVER(
    ORDER BY monetary ASC
) AS monetary_score;


/*
===============================================================================
42. CUSTOMER LIFETIME DAYS
===============================================================================

Formula:

    Last Purchase Date - First Purchase Date

Average days between orders:

    Lifetime Days
    -------------
    Total Orders - 1
===============================================================================
*/


/*
===============================================================================
43. SELLER PERFORMANCE
===============================================================================

Common seller metrics:

    Total Orders
    Total Items Sold
    Total Revenue
    Average Item Price

Important:

    COUNT(DISTINCT order_id)
        → Number of orders

    COUNT(product_id)
        → Number of items sold

    SUM(price)
        → Revenue
===============================================================================
*/


/*
===============================================================================
44. DELIVERY ANALYSIS
===============================================================================

Delivery days:

    Delivered Date - Approved Date

Late delivery:

    Delivered Date > Estimated Delivery Date

Useful metrics:

    Total Orders
    Average Delivery Days
    Late Orders
    Late Delivery Percentage
===============================================================================
*/

CASE
    WHEN delivered_date > estimated_delivery_date
        THEN 1
    ELSE 0
END AS late_delivery;


/*
===============================================================================
45. LATE DELIVERY PERCENTAGE
===============================================================================
*/

(
    late_orders /
    NULLIF(total_orders, 0)
) * 100;


/*
===============================================================================
46. PRODUCT CATEGORY ANALYSIS
===============================================================================

Common metrics:

    Products Sold
    Orders
    Revenue
    Average Item Price

Pattern:
===============================================================================
*/

COUNT(product_id) AS total_products_sold,

COUNT(DISTINCT order_id) AS total_orders,

SUM(price) AS total_revenue,

AVG(price) AS average_item_price;


/*
===============================================================================
47. PRODUCT PRICE VS CATEGORY AVERAGE
===============================================================================

Business logic:

    Calculate average price per product
        ↓
    Calculate average product price per category
        ↓
    Compare product against category average

Pattern:

    Product Average Price
            >
    Category Average Price
===============================================================================
*/


/*
===============================================================================
48. SELLER REVENUE VS STATE AVERAGE
===============================================================================

Business logic:

    Calculate seller revenue
        ↓
    Calculate average seller revenue per state
        ↓
    Compare seller against state average

Pattern:

    Seller Revenue
          >
    State Average Revenue
===============================================================================
*/


/*
===============================================================================
49. HIGH-VALUE AT-RISK CUSTOMER
===============================================================================

Business definition used in this project:

    High Value:
        Total spending > average customer spending

    At Risk:
        Recency > 90 days

Combined:

    total_spent > AVG(total_spent) OVER()
    AND
    recency_days > 90
===============================================================================
*/


/*
===============================================================================
50. BUSINESS QUESTION → SQL PATTERN
===============================================================================

Question:
    Top customers

Think:
    GROUP BY customer
    → SUM()
    → DENSE_RANK()
    → Top N


Question:
    Top 3 products in each category

Think:
    GROUP BY product/category
    → DENSE_RANK()
    → PARTITION BY category
    → rank <= 3


Question:
    Month-over-month revenue

Think:
    GROUP BY month
    → LAG()
    → revenue change
    → growth percentage


Question:
    Cumulative revenue

Think:
    GROUP BY month
    → SUM() OVER(ORDER BY month)


Question:
    Previous transaction

Think:
    LAG()


Question:
    Next transaction

Think:
    LEAD()


Question:
    Percentage contribution

Think:
    value / SUM(value) OVER() * 100


Question:
    Percentage contribution within month/category/state

Think:
    SUM(value) OVER(PARTITION BY group)


Question:
    Rank within each state/category

Think:
    RANK() / DENSE_RANK()
    + PARTITION BY


Question:
    Divide customers into quartiles

Think:
    NTILE(4)


Question:
    Above-average customers

Think:
    AVG(value) OVER()


Question:
    First purchase

Think:
    MIN(date)


Question:
    Last purchase

Think:
    MAX(date)


Question:
    Repeat customers

Think:
    COUNT(DISTINCT order_id) > 1


Question:
    Customer cohort

Think:
    MIN(purchase_date)
    → DATE_TRUNC('month')


Question:
    Customer lifetime

Think:
    MAX(date) - MIN(date)


Question:
    RFM analysis

Think:
    Recency + Frequency + Monetary
    → NTILE()
    → RFM score


Question:
    Late deliveries

Think:
    Delivered Date > Estimated Date
===============================================================================
*/


/*
===============================================================================
51. SQL EXECUTION / THINKING ORDER
===============================================================================

When solving SQL problems, mentally think:

    FROM
      ↓
    JOIN
      ↓
    WHERE
      ↓
    GROUP BY
      ↓
    HAVING
      ↓
    SELECT
      ↓
    WINDOW FUNCTIONS
      ↓
    ORDER BY
      ↓
    LIMIT

Important:

    Window functions cannot normally be filtered directly in WHERE
    at the same query level.

Use:

    CTE / Subquery
        ↓
    Window Function
        ↓
    Outer WHERE
===============================================================================
*/


/*
===============================================================================
52. COMMON MISTAKES TO AVOID
===============================================================================

1. COUNT(order_id) vs COUNT(DISTINCT order_id)

    An order can have multiple order_items.

    Use:

        COUNT(DISTINCT order_id)

    when calculating number of orders.


2. Using WHERE for aggregate filters

    Wrong:

        WHERE SUM(price) > 1000

    Correct:

        HAVING SUM(price) > 1000


3. Filtering a window function in the same query level

    Wrong:

        WHERE customer_rank <= 10

    if customer_rank is created in that same SELECT.

    Correct:

        Create rank in CTE/subquery
            ↓
        Filter in outer query.


4. Incorrect PARTITION BY

    AVG(total_spent) OVER(
        PARTITION BY customer_unique_id
    )

    may return each customer's own value when there is one row per customer.

    For overall average:

        AVG(total_spent) OVER()


5. Division by zero

    Use:

        NULLIF(denominator, 0)


6. Month ordering

    Prefer:

        DATE_TRUNC('month', timestamp)

    rather than:

        TO_CHAR(timestamp, 'Month')

    when chronological ordering is required.


7. LIMIT vs rank filtering

    LIMIT 10:
        Exactly 10 rows.

    DENSE_RANK() + rank <= 10:
        Top 10 ranks and can include ties.
===============================================================================
*/


/*
===============================================================================
53. CORE WINDOW FUNCTION CHEAT SHEET
===============================================================================

RANK:

    RANK() OVER(
        ORDER BY value DESC
    )


DENSE_RANK:

    DENSE_RANK() OVER(
        ORDER BY value DESC
    )


ROW_NUMBER:

    ROW_NUMBER() OVER(
        ORDER BY value DESC
    )


PARTITION:

    RANK() OVER(
        PARTITION BY category
        ORDER BY revenue DESC
    )


LAG:

    LAG(value) OVER(
        ORDER BY date
    )


LEAD:

    LEAD(value) OVER(
        ORDER BY date
    )


RUNNING TOTAL:

    SUM(value) OVER(
        ORDER BY date
    )


GROUP TOTAL:

    SUM(value) OVER(
        PARTITION BY category
    )


OVERALL AVERAGE:

    AVG(value) OVER()


QUARTILES:

    NTILE(4) OVER(
        ORDER BY value
    )
===============================================================================
*/


/*
===============================================================================
54. FINAL SQL PROBLEM-SOLVING FRAMEWORK
===============================================================================

Before writing SQL, ask:

1. What is the required output grain?

    One row per:
        Customer?
        Order?
        Product?
        Seller?
        Category?
        Month?
        State?

2. Which tables contain the required columns?

3. Do I need JOINs?

4. Do I need aggregation?

5. What should I GROUP BY?

6. Do I need to compare rows?

    Previous → LAG()
    Next     → LEAD()

7. Do I need ranking?

    Ranking → RANK / DENSE_RANK / ROW_NUMBER

8. Does ranking restart by group?

    Yes → PARTITION BY

9. Do I need cumulative values?

    Yes → SUM() OVER(ORDER BY ...)

10. Do I need percentage contribution?

    value / SUM(value) OVER(...)

11. Do I need to divide safely?

    NULLIF(denominator, 0)

12. Do I need to filter an aggregate?

    HAVING

13. Do I need to filter a window function?

    CTE / Subquery + outer WHERE

14. Does the question involve time?

    DATE_TRUNC()
    MIN()
    MAX()
    LAG()
    LEAD()

15. Is this a business classification?

    CASE
===============================================================================
*/


/*
===============================================================================
END OF SQL QUERY SUMMARY
===============================================================================
*/