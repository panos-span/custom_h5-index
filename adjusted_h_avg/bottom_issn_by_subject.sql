CREATE TABLE rolap.bottom_issn_by_subject AS
    SELECT issn, subject
    FROM (SELECT issn,
                 subject,
                 PERCENT_RANK() OVER (PARTITION BY subject ORDER BY impact_factor DESC) AS issn_percentile_rank
          FROM rolap.impact_factor) ranked_issns
    WHERE issn_percentile_rank >= 0.5;