-- Question 4: Which cities and sites appear in the most studies, and what share of
-- studies is concentrated in the largest cities?
-- Cities are ranked by number of studies. Each study is counted once, at the
-- highest-ranked city where it has a site (bestRank). Cumulative share =
-- studies with at least one site in the top N cities, without double counting.
WITH city_rank AS (
    SELECT city,
           ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT nctId) DESC) AS rnk
    FROM sites
    WHERE city <> 'Unknown city'
    GROUP BY city
),
study_best AS (
    SELECT t.nctId, MIN(r.rnk) AS bestRank
    FROM sites AS t
    JOIN city_rank AS r ON r.city = t.city
    GROUP BY t.nctId
)
SELECT b.bestRank AS topN,
       c.city,
       COUNT(*) AS newStudies,
       SUM(COUNT(*)) OVER (ORDER BY b.bestRank) AS cumStudies,
       ROUND(100.0 * SUM(COUNT(*)) OVER (ORDER BY b.bestRank)
             / (SELECT COUNT(*) FROM studies), 1) AS cumPct
FROM study_best AS b
JOIN city_rank AS c ON c.rnk = b.bestRank
GROUP BY b.bestRank, c.city
ORDER BY b.bestRank
LIMIT 10;
