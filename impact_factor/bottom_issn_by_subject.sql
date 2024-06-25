CREATE TABLE rolap.bottom_issn_by_subject AS
    WITH ranked_issns AS (
        SELECT issn,
               subject,
               impact_factor,
               PERCENT_RANK() OVER (PARTITION BY subject ORDER BY impact_factor ASC) AS percent_rank
        FROM rolap.impact_factor
    )
    SELECT issn, subject
    FROM ranked_issns
    WHERE percent_rank <= 0.5;