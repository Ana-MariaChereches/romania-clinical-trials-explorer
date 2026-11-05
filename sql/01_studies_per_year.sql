-- Question 1: How has the number of studies with Romanian sites evolved per start year?
-- Only studies with an actual start date; the current year is partial.
SELECT CAST(startYear AS INTEGER) AS startYear,
       COUNT(*) AS studies
FROM studies
WHERE startKind = 'actual'
GROUP BY startYear
ORDER BY startYear;
