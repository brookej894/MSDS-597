/*
Question 1
 */
SELECT
    CASE WHEN (avg_vote) >= 9.0 THEN 'Great'
        WHEN (avg_vote) BETWEEN 8.0 AND 8.9 THEN 'Good'
        WHEN (avg_vote) BETWEEN 7.0 AND 7.9 THEN'Decent'
        WHEN (avg_vote) BETWEEN 6.0 AND 6.9 THEN 'Questionable'
        ELSE 'Bad' END AS rating_category,
    COUNT(imdb_title_id) AS num_movies
FROM movies
WHERE votes >= 10000
GROUP BY 1
ORDER BY 2 DESC;
/*
Question 2
 */

SELECT
    production_company,
    SUM(CAST(
        LTRIM(usa_gross_income,'$ ') AS NUMERIC)) AS total_usa_gross_income
FROM movies
WHERE movies.usa_gross_income ILIKE '%$%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

/*
Question 3
*/

SELECT
    year,
    COUNT(imdb_title_id) AS num_movies,
    ROUND(AVG(avg_vote), 1) AS avg_rating,
    MAX(avg_vote) AS max_rating,
    MIN(avg_vote) AS min_rating
FROM movies
WHERE votes >= 10000
    AND year BETWEEN 2001 AND 2010
GROUP BY year
ORDER BY year ASC;


/*
 Question 4
 */

SELECT
    COUNT(imdb_title_id) AS num_2008_movies_above_average
FROM movies
WHERE avg_vote > 6.4
    AND year = 2008
    AND votes >= 10000;

/*
Question 5
 */

SELECT
    CASE WHEN DATE_PART('month', DATE(date_published)) IN (12, 01, 02) THEN 'Winter'
        WHEN DATE_PART('month', DATE(date_published)) IN (03, 04, 05) THEN 'Spring'
        WHEN DATE_PART('month', DATE(date_published)) IN (06, 07, 08) THEN 'Summer'
        WHEN DATE_PART('month', DATE(date_published)) IN (09, 10, 11) THEN 'Fall'
        END AS season,
    COUNT(imdb_title_id) AS num_movies,
    ROUND(AVG(CAST(LTRIM(budget, '$') AS NUMERIC)), 2) AS avg_budget,
    ROUND(AVG(CAST(LTRIM(usa_gross_income,'$ ') AS NUMERIC)), 2) AS avg_usa_gross_income,
    ROUND(AVG(CAST(LTRIM(worlwide_gross_income,'$ ') AS NUMERIC)), 2) AS avg_worldwide_gross_income
FROM movies
WHERE year >= 1990
    AND votes >=10000
    AND budget LIKE '%$%'
    AND date_published LIKE '____-__-__'
GROUP BY season
ORDER BY avg_worldwide_gross_income DESC;
/*
Question 6
*/


SELECT
    production_company,
    COUNT(imdb_title_id) AS num_movies,
    ROUND(AVG(avg_vote), 1) AS avg_rating,
    ROUND(MAX(avg_vote), 1) AS max_rating
FROM movies
WHERE votes >=10000
GROUP BY 1
HAVING MAX(avg_vote) >=9
ORDER BY max_rating DESC, production_company ASC;

/*
 Question 7
 */
SELECT
    CONCAT(LEFT(date_of_birth, 3), '0s') AS birth_decade,
    COUNT(CASE WHEN place_of_birth ILIKE '%California%' THEN place_of_birth END) AS count_california_born,
    COUNT(imdb_name_id) AS count_total,
    ROUND
        (CAST
            (COUNT
                (CASE WHEN place_of_birth ILIKE '%California%' THEN place_of_birth END) AS NUMERIC)*100/CAST(COUNT(imdb_name_id)
                    AS NUMERIC), 1) AS pct_california_born
FROM actors
WHERE date_of_birth LIKE '____-__-__'
    AND DATE_PART('year', DATE(date_of_birth)) >= 1900
GROUP BY birth_decade
ORDER BY birth_decade;

/*
 Question 8
 */

SELECT
    SPLIT_PART(name, ' ', 1) AS first_name,
    COUNT(imdb_name_id) AS num_actors
FROM actors
GROUP BY first_name
ORDER BY num_actors DESC
LIMIT 10;

/*
 Question 9
 */
SELECT
    COUNT(DISTINCT(production_company)) as num_production_companies
FROM movies;


/*
Question 10
 */

SELECT
    CASE WHEN EXTRACT(DOW from DATE(date_published)) = 0 THEN 'Sunday'
        WHEN EXTRACT(DOW from DATE(date_published)) = 1 THEN 'Monday'
        WHEN EXTRACT(DOW from DATE(date_published)) = 2 THEN 'Tuesday'
        WHEN EXTRACT(DOW from DATE(date_published)) = 3 THEN 'Wednesday'
        WHEN EXTRACT(DOW from DATE(date_published)) = 4 THEN 'Thursday'
        WHEN EXTRACT(DOW from DATE(date_published)) = 5 THEN 'Friday'
        WHEN EXTRACT(DOW from DATE(date_published)) = 6 THEN 'Saturday'
        END AS day_of_week,
    COUNT(imdb_title_id) AS num_movies
FROM movies
WHERE date_published LIKE '____-__-__'
GROUP BY day_of_week
ORDER BY num_movies DESC;
