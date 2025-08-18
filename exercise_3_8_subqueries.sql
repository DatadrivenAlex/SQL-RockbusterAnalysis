-- Exercise 3.8: Performing Subqueries

-- Query 1: Average Spending of Top 5 Customers
SELECT AVG(total_spent) AS average_paid_by_top_5_customers
FROM (
  SELECT 
    A.customer_id,
    B.first_name,
    B.last_name,
    E.country,
    D.city,
    SUM(A.amount) AS total_spent,
    B.email
  FROM payment A
  INNER JOIN customer B ON A.customer_id = B.customer_id
  INNER JOIN address C ON B.address_id = C.address_id
  INNER JOIN city D ON C.city_id = D.city_id
  INNER JOIN country E ON D.country_id = E.country_id
  WHERE city IN ('Aurora', 'Linares', 'Gdynia', 'So Leopoldo', 'Sivas', 
                 'Xintai', 'Adoni', 'Celaya', 'Tebessa', 'Tianjin',
                 'Changzhi', 'Dhule (Dhulla)', 'Pingxiang', 'Khursak')
  GROUP BY A.customer_id, B.first_name, B.last_name, B.email, D.city, E.country
  ORDER BY total_spent DESC
  LIMIT 5
) AS top_customers;

-- Query 2: Top 5 Customer Count by Country
SELECT *
FROM (
  SELECT 
    A.customer_id,
    B.first_name,
    B.last_name,
    D.city,
    E.country,
    SUM(A.amount) AS total_payment
  FROM payment A
  INNER JOIN customer B ON A.customer_id = B.customer_id
  INNER JOIN address C ON B.address_id = C.address_id
  INNER JOIN city D ON C.city_id = D.city_id
  INNER JOIN country E ON D.country_id = E.country_id
  WHERE D.city IN ('Aurora', 'Linares', 'Gdynia', 'So Leopoldo', 'Sivas', 
                   'Xintai', 'Adoni', 'Celaya', 'Tebessa', 'Tianjin',
                   'Changzhi', 'Dhule (Dhulla)', 'Pingxiang', 'Khursak')
  GROUP BY A.customer_id, B.first_name, B.last_name, B.email, D.city, E.country
  ORDER BY total_payment DESC
  LIMIT 5
) AS top_customers
LEFT JOIN (
  SELECT 
    E.country,
    COUNT(*) AS all_customer_count
  FROM payment A
  INNER JOIN customer B ON A.customer_id = B.customer_id
  INNER JOIN address C ON B.address_id = C.address_id
  INNER JOIN city D ON C.city_id = D.city_id
  INNER JOIN country E ON D.country_id = E.country_id
  GROUP BY E.country
) AS all_customers
ON top_customers.country = all_customers.country
GROUP BY top_customers.country, all_customers.all_customer_count;
