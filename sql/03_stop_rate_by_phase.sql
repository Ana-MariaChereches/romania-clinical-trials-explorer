-- Question 6: What share of studies stop, by phase?
-- Studies with start year 2015-2021 (later studies have had less time to stop).
-- Stopped = TERMINATED or WITHDRAWN; SUSPENDED is left out of numerator and denominator.
-- Start type is not filtered: withdrawn studies mostly have only a planned start date.
SELECT phaseLabel,
       COUNT(*) AS studies,
       SUM(CASE WHEN status IN ('TERMINATED', 'WITHDRAWN') THEN 1 ELSE 0 END) AS stopped,
       ROUND(100.0 * SUM(CASE WHEN status IN ('TERMINATED', 'WITHDRAWN') THEN 1 ELSE 0 END)
             / COUNT(*), 1) AS stopPct
FROM studies
WHERE startYear BETWEEN 2015 AND 2021
  AND status <> 'SUSPENDED'
GROUP BY phaseLabel
ORDER BY studies DESC;
