/*
Question 1
Let's compare the combo genres "Rom-Com" and "Dramedy" by their
average rating (average of avg_vote) and # of movies. Only use
movies with at least 10,000 votes as part of this analysis.

Definitions:
"Rom-Com" = A movie with both "Comedy" and "Romance" in the genre
"Dramedy" = A movie with both "Comedy" and "Drama" in the genre

If a movie has "Comedy", "Romance" AND "Drama" in the genre, it should
count in both categories.

You will create a new field called "combo_genre" which contains either
"Rom-Com" or "Dramedy".

Provide the output sorted by "combo_genre" alphabetically.

Hint:  Calculate the two "combo_genre" in separate queries and UNION the results together
*/
SELECT
    'Dramedy' AS combo_genre,
    ROUND(AVG(avg_vote),2) AS avg_rating,
    COUNT(1) AS num_movies
FROM(
    SELECT DISTINCT original_title,
                    genre,
                    avg_vote
    FROM movies
    WHERE genre ILIKE '%drama%' AND genre ILIKE '%comedy%'
        AND votes >= 10000
    ) dramedy
UNION ALL
SELECT
    'Rom-Com' AS combo_genre,
    ROUND(AVG(avg_vote), 2) AS avg_rating,
    COUNT(1) AS num_movies
FROM(
    SELECT DISTINCT original_title,
                    genre,
                    avg_vote
    FROM movies
    WHERE votes >= 10000
        AND genre ILIKE '%romance%' AND genre ILIKE '%comedy%'
    ) romcom
ORDER BY 1;

/*
Question 2
Provide a list of the top 10 movies (by votes) where the cast (actors/actresses) has at least
4 members and the cast consists only of actresses (no actors).

The columns you should report are "original_title", "avg_vote" and "votes",
all from the "movies" table.

Consider only movies with at least 10,000 votes.

Hint: Consider writing a subquery to filter to the
imdb_title_id of movies that fit this criteria. 
This subquery should involve the following:
- joins between actors, title_principals, and movies
- filters to actor/actress only and movies with votes >= 10000
- group by imdb_title_id
- conditions in the HAVING clause that match the aggregate conditions you need 
(i.e. at least 4 actors/actresses combined and no actors)
*/

SELECT
    m.original_title,
    m.avg_vote,
    m.votes
FROM movies m
INNER JOIN (
    SELECT DISTINCT imdb_title_id,
           COUNT(imdb_name_id) OVER (PARTITION BY imdb_title_id ORDER BY imdb_title_id) AS num_actresses
    FROM title_principals
    WHERE category = 'actress'
    ) a
ON a.imdb_title_id = m.imdb_title_id
WHERE votes >= 10000
    AND a.num_actresses >= 4
ORDER BY 3 DESC
LIMIT 10;

/*
Question 3
What is the consensus worst movie for each production company?
Find the movie with the most votes but with avg_vote <= 5 for each production company.
Provide the top 10 movies ordered by votes (from highest to lowest)

Hint: Use an analytic function to find the top voted movie per production company
 */
SELECT
    *
FROM(
    SELECT
        original_title,
        production_company,
        avg_vote,
        votes,
        RANK() OVER (PARTITION BY production_company ORDER BY votes DESC) AS rank
    FROM movies
    WHERE avg_vote <= 5.0) m
WHERE rank = 1
ORDER BY 4 DESC
LIMIT 10;

/*
Question 4
What was the longest gap between movies published by production company "Marvel Studios"?
Use "date_published" as the date.
Return the gap as a field called "gap_length" that is an Interval data type
calculated by using the AGE() function.
AGE() documentation can be found here: https://www.postgresql.org/docs/current/functions-datetime.html

Hint: Use an analytic function to align each Marvel movie with the movie
released immediately prior to it.
*/
 SELECT
    *,
    AGE(DATE(b.date_published), DATE(b.prev_date_published)) AS gap_length
FROM (
         SELECT original_title,
                date_published,
                LAG(original_title, 1)
                OVER (PARTITION BY production_company ORDER BY date_published) AS prev_original_title,
                LAG(date_published, 1)
                OVER (PARTITION BY production_company ORDER BY date_published) AS prev_date_published
        FROM (
            SELECT
                   original_title,
                   production_company,
                   date_published
            FROM movies
            ORDER BY 2 ASC) m
        WHERE production_company = 'Marvel Studios'
     ) b
 WHERE prev_original_title IS NOT NULL
ORDER BY gap_length DESC
LIMIT 1;

/*
Question 5
Of all Zoe Saldana movies (movies where she is listed in the actors column of the movies table),
what is the % of total worldwide gross income contributed by each movie?
Round the % to 2 decimal places, sort from highest % to lowest %,
and return the top 10.

Numerator = worlwide_gross_income for each Zoe Saldana movie
Denominator = total worlwide_gross_income for all Zoe Saldana movies

Filter out any movies with null worlwide_gross_income

Hint: Use an analytic function to place the total (denominator) on each row
to make the calculation easy
*/
SELECT
    original_title,
    ROUND((worldwide_gross_income/total_worldwide_gross_income *100), 2) AS pct_total_gross_income
FROM (
         SELECT *,
                SUM(worldwide_gross_income) OVER () AS total_worldwide_gross_income
         FROM (
                  SELECT original_title,
                         CAST(LTRIM(worlwide_gross_income, '$ ') AS NUMERIC) AS worldwide_gross_income
                  FROM movies
                  WHERE actors ILIKE '%zoe saldana%'
                        AND worlwide_gross_income IS NOT NULL
              ) a
     ) b
ORDER BY 2 DESC
LIMIT 10;

SELECT
    original_title,
    date_published
FROM movies
WHERE date_published ILIKE '____-07-04'
    AND votes >= 100000
    AND avg_vote <5;


SELECT
    year
FROM (
    SELECT imdb_title_id,
           avg_vote,
           COUNT(imdb_title_id) OVER (PARTITION BY year) AS movie_count,
           year
    FROM movies
    WHERE genre ILIKE '%Comedy%'
        AND votes >= 10000
        AND avg_vote < 6.1
            ) a
WHERE movie_count >100
GROUP BY (1)


SELECT
    year,
    COUNT(imdb_title_id) OVER (PARTITION BY year) AS movie_count
FROM (
    SELECT imdb_title_id,
            avg_vote,
            year
    FROM movies
    WHERE genre ILIKE '%Comedy%'
        AND votes >= 10000
        AND avg_vote < 6.1
        ) a
WHERE movie_count

SELECT
    four_cats,
    count_four_cats
FROM(
    SELECT
        COUNT(four_cats) OVER(PARTITION BY four_cats) AS count_four_cats,
        four_cats
    FROM(
        SELECT
            m.imdb_title_id,
            CASE WHEN females_allages_avg_vote > males_allages_avg_vote AND allgenders_18age_avg_vote > allgenders_45age_avg_vote THEN 'FY'
                WHEN females_allages_avg_vote > males_allages_avg_vote AND allgenders_18age_avg_vote < allgenders_45age_avg_vote THEN 'FO'
                WHEN females_allages_avg_vote < males_allages_avg_vote AND allgenders_18age_avg_vote > allgenders_45age_avg_vote THEN 'MY'
                WHEN females_allages_avg_vote < males_allages_avg_vote AND allgenders_18age_avg_vote < allgenders_45age_avg_vote THEN 'MO'
                END AS four_cats
        FROM movies m
        LEFT JOIN ratings r
        ON r."imdb_title_id"=m."imdb_title_id"
        WHERE m.votes >=10000
            AND production_company ILIKE '%warner bros%') a ) b
WHERE four_cats IS NOT NULL
GROUP BY 1, 2
ORDER BY 2 DESC;

SELECT
    CASE WHEN prod_co_rank = 1 AND director_rank = 1 THEN original_title END AS top_three,
    avg_vote
FROM(
    SELECT
        original_title,
        production_company,
        director,
        avg_vote,
        RANK() OVER (PARTITION BY production_company ORDER BY votes ASC) AS prod_co_rank,
        RANK() OVER (PARTITION BY director ORDER BY votes ASC) AS director_rank
    FROM movies
    WHERE votes IS NOT NULL
        AND production_company IS NOT NULL
    ORDER BY 4 ASC, 5 ASC) a
ORDER BY 2;


SELECT
    director
FROM(
    SELECT
        director,
        RANK() OVER (PARTITION BY director ORDER BY votes ASC) AS director_rank
    FROM movies
    ORDER BY 2) a
GROUP BY 1;


 SELECT
    production_company,
     RANK() OVER (PARTITION BY production_company ORDER BY votes ASC) AS prod_co_rank
FROM (
    SELECT
         production_company,
         SUM(votes) AS votes
    FROM movies
    WHERE votes IS NOT NULL
    GROUP BY 1) b
ORDER BY 2;

