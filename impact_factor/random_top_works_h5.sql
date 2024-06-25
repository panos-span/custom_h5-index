CREATE INDEX IF NOT EXISTS work_authors_orcid_idx ON work_authors (orcid);

-- Create the table rolap.random_top_works
CREATE TABLE rolap.random_top_works_h5 AS
WITH top_authors AS (
    SELECT orcid, subject, h5_index,
           ROW_NUMBER() OVER (PARTITION BY subject ORDER BY h5_index DESC) AS rn
    FROM rolap.orcid_h5_subject
    WHERE h5_index >= 35
),
filtered_top_authors AS (
    SELECT orcid, subject, h5_index
    FROM top_authors
    WHERE rn <= 10
),
top_author_works AS (
    SELECT DISTINCT works.doi, filtered_top_authors.subject, h5_index
    FROM filtered_top_authors
    INNER JOIN work_authors ON work_authors.orcid = filtered_top_authors.orcid
    INNER JOIN works ON work_authors.work_id = works.id
),
top_work_citations AS (
    SELECT works.id, citations_number, top_author_works.subject
    FROM top_author_works
    INNER JOIN works ON top_author_works.doi = works.doi
    INNER JOIN rolap.work_citations ON rolap.work_citations.doi = top_author_works.doi
),
ranked_works AS (
    SELECT id, citations_number, subject,
           ROW_NUMBER() OVER (PARTITION BY subject ORDER BY substr(
                 id * 0.54534238371923827955579364758491,
                 length(id) + 2
           )) AS rn
    FROM top_work_citations
)
SELECT DISTINCT id, citations_number, subject
FROM ranked_works
WHERE rn <= 50;