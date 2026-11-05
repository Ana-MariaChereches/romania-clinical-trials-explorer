-- Question 6: What share of studies stop, by phase?
-- Studies with start year 2015-2021 (later studies have had less time to stop).
-- Denominator: studies with a final status (COMPLETED, TERMINATED, WITHDRAWN).
-- Stopped = TERMINATED or WITHDRAWN. SUSPENDED is excluded everywhere.
-- Start type is not filtered: withdrawn studies mostly have only a planned start date.
-- The rate describes the whole study, not the Romanian sites.
SELECT phaseLabel,
       COUNT(*) AS studies,
       SUM(CASE WHEN status IN ('TERMINATED', 'WITHDRAWN') THEN 1 ELSE 0 END) AS stopped,
       ROUND(100.0 * SUM(CASE WHEN status IN ('TERMINATED', 'WITHDRAWN') THEN 1 ELSE 0 END)
             / COUNT(*), 1) AS stopPct
FROM studies
WHERE startYear BETWEEN 2015 AND 2021
  AND status IN ('COMPLETED', 'TERMINATED', 'WITHDRAWN')
GROUP BY phaseLabel
ORDER BY studies DESC;
