CREATE INDEX IF NOT EXISTS rolap.work_citations_citations_number_idx ON work_citations (citations_number);
CREATE INDEX IF NOT EXISTS rolap.random_top_works_citations_number_idx ON random_top_works (citations_number);

CREATE TABLE rolap.random_top_other_works AS
WITH candidate_works AS (
    SELECT random_top_works.id AS top_work_id,
           bottom_filtered_works_orcid.id AS other_work_id,
           random_top_works.citations_number,
           random_top_works.subject
    FROM rolap.random_top_works
    LEFT JOIN rolap.work_citations ON random_top_works.citations_number = work_citations.citations_number
    INNER JOIN bottom_filtered_works_orcid ON work_citations.doi = bottom_filtered_works_orcid.doi
    WHERE bottom_filtered_works_orcid.id != random_top_works.id
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