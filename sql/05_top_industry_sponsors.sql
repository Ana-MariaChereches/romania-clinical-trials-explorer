-- Question 3: Who are the most active sponsors (industry vs academic)?
-- Top industry sponsors by number of studies. Sponsors with a name that says they
-- belong to a company (for example "a Sanofi company") are grouped with it through
-- the hand-made table sponsor_alias; the other sponsors keep their registry name.
-- RANK gives equal rank to equal counts.
SELECT COALESCE(a.sponsorGroup, s.sponsor) AS sponsorName,
       COUNT(*) AS studies,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM studies), 1) AS pctOfStudies
FROM studies AS s
LEFT JOIN sponsor_alias AS a ON a.sponsor = s.sponsor
WHERE s.sponsorClass = 'INDUSTRY'
GROUP BY sponsorName
ORDER BY studies DESC
LIMIT 15;
