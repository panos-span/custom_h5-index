-- Creates a view that lists the top 20 ISSNs by subject based on the H5 index.

CREATE VIEW rolap.top_issn_by_subject AS
(
SELECT issn, subject
FROM (SELECT issn,
             subject,
             ROW_NUMBER() OVER (PARTITION BY subject ORDER BY h5_index DESC) AS issn_rank
      FROM rolap.issn_subject_h5) ranked_issns
WHERE issn_rank <= 20
    ) -- Table that has the filtered works and ensures that for each subject associated with a work,
-- the ISSN of the work is checked to see if it is in the top 20 for that subject
