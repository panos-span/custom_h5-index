-- Create index if it doesn't exist
CREATE INDEX IF NOT EXISTS work_authors_orcid_idx ON work_authors(orcid);

-- Create the table for random top works by subject
CREATE TABLE rolap.random_top_works AS
WITH random_authors AS (
    SELECT orcid, subject
    FROM (
        SELECT orcid, subject
        FROM rolap.orcid_h5_filtered
        ORDER BY substr(orcid * 0.54534238371923827955579364758491, length(orcid) + 2)
        LIMIT 50
    )
),
top_author_works AS (
    SELECT DISTINCT works.doi, random_authors.subject
    FROM random_authors
    INNER JOIN work_authors ON work_authors.orcid = random_authors.orcid
    INNER JOIN works ON work_authors.work_id = works.id
),
top_work_citations AS (
    SELECT works.id, citations_number, top_author_works.subject
    FROM top_author_works
    INNER JOIN works ON top_author_works.doi = works.doi
    INNER JOIN rolap.work_citations ON work_citations.doi = top_author_works.doi
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
