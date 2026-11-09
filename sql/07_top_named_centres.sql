-- Question 4: Which sites (centres) appear in the most studies?
-- A centre is a (city, facility name) pair. Sites without a real name
-- ("Generic site") and the grouped "Private practice" label are excluded,
-- so this is a ranking of named centres only.
SELECT city,
       facility,
       COUNT(DISTINCT nctId) AS studies
FROM sites
WHERE facility NOT IN ('Generic site', 'Private practice')
GROUP BY city, facility
ORDER BY studies DESC
LIMIT 15;
