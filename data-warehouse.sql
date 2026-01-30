show databases;
CREATE DATABASE demoapp;
use demoapp;
show tables;
select * from student_db;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Student_DB WHERE ST_MARK = 0 or st_mark=66;
DELETE FROM Student_DB WHERE ID IS NULL;

CREATE TABLE sales_dw (
    id      INT AUTO_INCREMENT PRIMARY KEY,
    revenue INT,
    cost    INT
);
insert into sales_dw(revenue,cost) values (107,55);
INSERT INTO sales_dw (revenue, cost)
SELECT
    100 + (ROW_NUMBER() OVER() * 7 % 200),
    50  + (ROW_NUMBER() OVER() * 5 % 150)
FROM information_schema.tables
LIMIT 1000;


select * from sales_dw;
-- Mean
SELECT AVG(revenue) AS mean_revenue
FROM sales_dw; 


-- median
SELECT
AVG(revenue) AS median
FROM (
    SELECT
        revenue,
        ROW_NUMBER() OVER (ORDER BY revenue) AS rn,
        COUNT(*) OVER () AS total
    FROM sales_dw
) t
WHERE rn IN (FLOOR((total + 1) / 2), CEIL((total + 1) / 2));

WITH ordered AS (
    SELECT
        revenue,
        ROW_NUMBER() OVER (ORDER BY revenue) AS rn,
        COUNT(*) OVER () AS total
    FROM sales_dw
)
SELECT AVG(revenue) AS median
FROM ordered
WHERE rn IN (
    FLOOR((total + 1) / 2),
    CEIL((total + 1) / 2)
);

-- mode
SELECT revenue AS mode
FROM sales_dw
GROUP BY revenue
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT revenue AS mode,count(revenue) as count
FROM sales_dw
GROUP BY revenue
ORDER BY COUNT(*) DESC;

-- Standard Deviation
SELECT STDDEV_POP(revenue) AS std_deviation
FROM sales_dw;

-- Covariance (Revenue, Cost) 
SELECT
    AVG((revenue - r_mean) * (cost - c_mean)) AS covariance
FROM sales_dw,
     (SELECT AVG(revenue) r_mean, AVG(cost) c_mean FROM sales_dw) m;
     
-- Correlation
-- SELECT CORR(revenue, cost) AS correlation
-- FROM sales_dw;

SELECT
    SUM((revenue - avg_rev) * (cost - avg_cost)) /
    SQRT(
        SUM(POW(revenue - avg_rev, 2)) *
        SUM(POW(cost - avg_cost, 2))
    ) AS correlation
FROM sales_dw,
     (SELECT AVG(revenue) AS avg_rev, AVG(cost) AS avg_cost FROM sales_dw) m;
     
     
-- Rank
SELECT
    id,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM sales_dw;

-- Quartiles


-- SELECT
--    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY revenue) AS Q1,
--    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY revenue) AS Q2,
 --   PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revenue) AS Q3
-- FROM sales_dw;--

  WITH ordered AS (
    SELECT
        revenue,
        ROW_NUMBER() OVER (ORDER BY revenue) AS rn,
        COUNT(*) OVER () AS total
    FROM sales_dw
)
SELECT
    MAX(CASE WHEN rn = FLOOR((total + 3) / 4) THEN revenue END) AS Q1,
    MAX(CASE WHEN rn = FLOOR((total + 1) / 2) THEN revenue END) AS Q2,
    MAX(CASE WHEN rn = FLOOR((3*total + 1) / 4) THEN revenue END) AS Q3
FROM ordered;

