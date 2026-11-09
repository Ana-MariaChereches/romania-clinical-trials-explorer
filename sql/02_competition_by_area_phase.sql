-- Questions 2 and 5: Which therapeutic areas and phases dominate active studies,
-- and how many active studies, sponsors, cities and named centres compete in each
-- area x phase.
-- Active = RECRUITING, ACTIVE_NOT_RECRUITING, ENROLLING_BY_INVITATION;
-- NOT_YET_RECRUITING is included and counted separately (notYet).
-- Studies can belong to several areas, so rows must not be added up.
-- namedCentres excludes sites without a real name ("Generic site"), so it is a minimum.
SELECT a.area,
       s.phaseLabel,
       COUNT(DISTINCT s.nctId) AS studies,
       COUNT(DISTINCT CASE WHEN s.status = 'NOT_YET_RECRUITING' THEN s.nctId END) AS notYet,
       COUNT(DISTINCT s.sponsor) AS sponsors,
       COUNT(DISTINCT CASE WHEN t.city <> 'Unknown city' THEN t.city END) AS cities,
       COUNT(DISTINCT CASE WHEN t.facility <> 'Generic site'
                           THEN t.city || '|' || t.facility END) AS namedCentres,
       CASE WHEN COUNT(DISTINCT s.nctId) < 5 THEN 'limited data' ELSE '' END AS note
FROM studies AS s
JOIN study_area AS a ON a.nctId = s.nctId
JOIN sites AS t ON t.nctId = s.nctId
WHERE s.status IN ('RECRUITING', 'ACTIVE_NOT_RECRUITING',
                   'ENROLLING_BY_INVITATION', 'NOT_YET_RECRUITING')
GROUP BY a.area, s.phaseLabel
ORDER BY studies DESC;
