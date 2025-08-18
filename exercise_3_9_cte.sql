-- Exercise 3.9: Common Table Expressions

-- Task 1A: Average Total Amount from Top Customers (using CTEs)
WITH top_10_countries AS (
  SELECT country_id
  FROM customer c
  JOIN address a ON c.address_id = a.address_id
  JOIN city ci ON a.city_id = ci.city_id
  JOIN country co ON ci.country_id = co.country_id
  GROUP BY country_id
  ORDER BY COUNT(*) DESC
  LIMIT 10
),
top_city AS (
  SELECT city_id
  FROM customer c
  JOIN address a ON c.address_id = a.address_id
  WHERE a.city_id IN (SELECT ci.city_id 
                      FROM city ci
                      JOIN top_10_countries tc ON ci.country_id = tc.country_id)
  GROUP BY city_id
  ORDER BY COUNT(*) DESC
  LIMIT 10
),
top_customer AS (
  SELECT c.customer_id, SUM(p.amount) AS total_payment
  FROM payment p
  JOIN customer c ON p.customer_id = c.customer_id
  JOIN address a ON c.address_id = a.address_id
  WHERE a.city_id IN (SELECT city_id FROM top_city)
  GROUP BY c.customer_id
  ORDER BY total_payment DESC
  LIMIT 5
)
SELECT AVG(total_payment) AS avg_top5_payment
FROM top_customer;

-- Task 1B: Customers by Country vs Top Customers
WITH all_customers AS (
  SELECT co.country, COUNT(DISTINCT c.customer_id) AS all_customer_count
  FROM customer c
  JOIN address a ON c.address_id = a.address_id
  JOIN city ci ON a.city_id = ci.city_id
  JOIN country co ON ci.country_id = co.country_id
  GROUP BY co.country
),
top_customers AS (
  SELECT co.country, COUNT(DISTINCT c.customer_id) AS top_customer_count
  FROM top_customer tc
  JOIN customer c ON tc.customer_id = c.customer_id
  JOIN address a ON c.address_id = a.address_id
  JOIN city ci ON a.city_id = ci.city_id
  JOIN country co ON ci.country_id = co.country_id
  GROUP BY co.country
)
SELECT ac.country, ac.all_customer_count, tc.top_customer_count
FROM all_customers ac
LEFT JOIN top_customers tc ON ac.country = tc.country;
