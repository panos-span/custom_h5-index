CREATE INDEX IF NOT EXISTS rolap.work_citations_citations_number_idx 
    ON work_citations (citations_number);
CREATE INDEX IF NOT EXISTS rolap.random_top_works_h5_citations_number_idx 
    ON random_top_works_h5 (citations_number);

CREATE TABLE rolap.random_top_other_works_h5 AS
WITH candidate_works AS (
    SELECT random_top_works_h5.id AS top_work_id,
           works_issn_subject.id AS other_work_id,
           random_top_works_h5.citations_number,
           random_top_works_h5.subject
    FROM rolap.random_top_works_h5
    LEFT JOIN rolap.work_citations ON random_top_works_h5.citations_number = work_citations.citations_number
    INNER JOIN works_issn_subject ON work_citations.doi = works_issn_subject.doi
    WHERE works_issn_subject.id != random_top_works_h5.id
),
random_candidate_works AS (
    SELECT other_work_id,
           citations_number,
           subject,
           ROW_NUMBER() OVER (
               PARTITION BY top_work_id, subject
               ORDER BY substr(
                   other_work_id * 0.54534238371923827955579364758491,
                   length(other_work_id) + 2
               )
           ) AS n
    FROM candidate_works
)
SELECT DISTINCT other_work_id AS id,
       citations_number,
       subject
FROM random_candidate_works
WHERE n = 1;