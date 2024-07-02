-- Impact factor of non-review journals

SELECT
    issn,
    title,
    subject,
    impact_factor
FROM rolap.impact_factor_titles
WHERE NOT title LIKE '%reviews%'
ORDER BY impact_factor DESC LIMIT 10;
