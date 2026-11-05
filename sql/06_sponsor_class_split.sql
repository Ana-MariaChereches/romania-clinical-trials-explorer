-- Question 3: Industry vs academic share of studies.
-- "Academic and other" groups the registry classes OTHER, NETWORK and OTHER_GOV.
SELECT CASE WHEN sponsorClass = 'INDUSTRY' THEN 'Industry'
            ELSE 'Academic and other' END AS sponsorType,
       COUNT(*) AS studies,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM studies), 1) AS pct
FROM studies
GROUP BY sponsorType;
