q3 = """
SELECT a.area,
       s.phaseLabel,
       COUNT(DISTINCT s.nctId) AS studies,
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
ORDER BY studies DESC
"""
print(pd.read_sql(q3, conn).head(25))
