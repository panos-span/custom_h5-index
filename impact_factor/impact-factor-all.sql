-- Impact factor of all journals under all their ISSNs

WITH clean_issns AS (
    -- Remove additional ISSN records that also exist as primary
    SELECT * FROM journals_issns
    EXCEPT
    SELECT additional.*
    FROM journals_issns AS additional
    INNER JOIN journals_issns AS main
        ON additional.issn = main.issn
    WHERE
        additional.issn_type = 'A'
        AND main.issn_type != 'A'
)

SELECT DISTINCT
    all_issns.issn,
    impact_factor,
    subject
FROM rolap.impact_factor
LEFT JOIN clean_issns AS main
    ON impact_factor.issn = main.issn
LEFT JOIN clean_issns AS all_issns
    ON main.journal_id = all_issns.journal_id
GROUP BY all_issns.issn, subject
ORDER BY impact_factor DESC;
