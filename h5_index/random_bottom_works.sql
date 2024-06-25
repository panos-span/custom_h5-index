CREATE INDEX IF NOT EXISTS work_authors_orcid_idx ON work_authors (orcid);

CREATE TABLE rolap.random_bottom_works AS
WITH bottom_orcids AS (
    SELECT orcid, subject, h5_index
    FROM rolap.orcid_h5_bottom
    WHERE h5_index > 8
),
bottom_author_works AS (
    SELECT DISTINCT works.doi, h5_index, bottom_orcids.subject
    FROM bottom_orcids
    INNER JOIN work_authors ON work_authors.orcid = bottom_orcids.orcid
    INNER JOIN works ON work_authors.work_id = works.id
),
bottom_work_citations AS (
    SELECT works.id, citations_number, bottom_author_works.subject
    FROM bottom_author_works
    INNER JOIN works ON bottom_author_works.doi = works.doi
    INNER JOIN rolap.work_citations ON work_citations.doi = bottom_author_works.doi
    WHERE work_citations.citations_number >= h5_index
),
ranked_works AS (
    SELECT id, citations_number, subject,
           ROW_NUMBER() OVER (PARTITION BY subject ORDER BY substr(
                 id * 0.54534238371923827955579364758491,
                 length(id) + 2
           )) AS rank
    FROM bottom_work_citations
)
SELECT id, citations_number, subject
FROM ranked_works
WHERE rank <= 50;