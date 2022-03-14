/*
Question 1
*/
SELECT
    name,
    height
FROM actors
WHERE
      spouses_string ILIKE '%Tom Cruise%'
ORDER BY name;

/*
Question 2
 */
SELECT
    name,
    spouses,
    divorces
FROM actors
ORDER BY divorces DESC, name ASC
LIMIT 5;

/*
Question 3
 */

SELECT
    original_title,
    year,
    genre,
    country,
    avg_vote,
    votes
FROM movies
WHERE
    genre ILIKE '%Horror%'
    AND country ILIKE '%USA%'
    AND votes >= 10000
ORDER BY avg_vote DESC, original_title ASC
LIMIT 5;

/*
Question 4
*/

SELECT
    name,
    date_of_birth,
    place_of_birth
FROM actors
WHERE
    death_details IS NULL
    AND date_of_birth ILIKE '%-02-29%'
    AND place_of_birth ILIKE '%USA%'
ORDER BY date_of_birth DESC, name ASC
LIMIT 10;

/*
Question 5
 */

SELECT
    original_title AS movie_title,
    duration AS length_in_minutes
FROM movies
WHERE
    production_company='Marvel Studios'
ORDER BY duration DESC
LIMIT 1;

/*
Question 6
*/

SELECT DISTINCT
    production_company
FROM movies
WHERE
    avg_vote >= 8.8
    AND votes >= 100000
ORDER BY production_company ASC;

/*
Question 7
*/

SELECT
    original_title,
    date_published,
    avg_vote
FROM movies
WHERE
    date_published BETWEEN '2017-12-25' AND '2018-01-01'
    AND votes >= 10000.0
ORDER BY avg_vote DESC;

/*
Question 8
*/

SELECT
    original_title,
    year,
    budget,
    CAST(
        LTRIM(worlwide_gross_income,'$ ') AS NUMERIC)
        AS worldwide_gross_income
FROM movies
WHERE
    description ILIKE '%zombie%'
    AND budget IS NOT NULL
    AND worlwide_gross_income IS NOT NULL
ORDER BY worldwide_gross_income DESC
LIMIT 5;



/*
Question 9
*/

SELECT
    name,
    height AS height_cm,
    CONCAT(
        FLOOR(height/(12*2.54)),
        ' feet ',
        ROUND((height - FLOOR(height/(12*2.54))*12*2.54)/2.54),
        ' inches'
        ) AS height_ft
FROM actors
WHERE height<300
ORDER BY height DESC, name ASC
LIMIT 10;

/*
Question 10
*/

SELECT
    original_title,
    usa_gross_income,
    worlwide_gross_income,
    ROUND(((CAST(LTRIM(usa_gross_income,'$ ')
        AS NUMERIC)*100)/(CAST(LTRIM(worlwide_gross_income, '$')
            AS NUMERIC))), 1)
    AS pct_gross_income_usa
FROM movies
WHERE
    actors ILIKE '%Tom Hanks%'
ORDER BY pct_gross_income_usa ASC
LIMIT 10;




