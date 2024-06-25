CREATE TABLE rolap.bottom_issn_by_subject AS
    SELECT issn, subject
    FROM (SELECT issn,
                 subject,
                 PERCENT_RANK() OVER (PARTITION BY subject ORDER BY h5_index ASC) AS issn_percentile_rank
          FROM rolap.issn_subject_h5) ranked_issns
    WHERE issn_percentile_rank <= 0.5;