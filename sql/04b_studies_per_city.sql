-- Question 4: number of studies per city (used for the city map).
-- A study counts once in every city where it has a site, so shares are not additive.
SELECT city,
       COUNT(DISTINCT nctId) AS studies,
       ROUND(100.0 * COUNT(DISTINCT nctId) / (SELECT COUNT(*) FROM studies), 1) AS pctOfStudies
FROM sites
WHERE city <> 'Unknown city'
GROUP BY city
ORDER BY studies DESC;
