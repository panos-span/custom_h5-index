-- Creates a table that lists the top 20 ISSNs by subject based on the H5 index.

CREATE TABLE rolap.top_issn_by_subject_h5 AS
    SELECT issn, subject
    FROM (SELECT issn,
                 subject,
                 PERCENT_RANK() OVER (PARTITION BY subject ORDER BY h5_index DESC) AS issn_percentile_rank
          FROM rolap.issn_subject_h5) ranked_issns
    WHERE issn_percentile_rank <= 0.25;
     -- Table that has the filtered works and ensures that for each subject associated with a work,
-- the ISSN of the work is checked to see if it is in the top 20 for that subject
