CREATE INDEX IF NOT EXISTS work_authors_orcid_idx ON work_authors (orcid);

CREATE TABLE rolap.random_top_works AS
-- Step 1: Select the top 50 authors per subject from orcid_h5_bottom
WITH top_bottom_authors AS (
    SELECT orcid, h5_index, subject, 
           ROW_NUMBER() OVER (PARTITION BY subject ORDER BY h5_index DESC) AS rn
    FROM rolap.orcid_h5_bottom
    WHERE h5_index IS NOT NULL
),
-- Step 2: Select random authors from orcid_h5_filtered with matching h-index
random_matching_authors AS (
    SELECT orcid, h5_index, subject,
           ROW_NUMBER() OVER (PARTITION BY h5_index ORDER BY substr(orcid * 0.54534238371923827955579364758491, length(orcid) + 2)) AS rn
    FROM rolap.orcid_h5_filtered
    WHERE (h5_index, subject) IN (SELECT h5_index, subject FROM top_bottom_authors) -- CHANGE with top_bottom_authors
),
-- Step 3: Ensure 1-to-1 matching based on row number (rn)
matched_authors AS (
    SELECT tba.orcid AS bottom_orcid,
           tba.h5_index AS bottom_h5_index,
           tba.subject AS bottom_subject,
           rma.orcid AS random_orcid,
           rma.h5_index AS random_h5_index,
           rma.subject AS random_subject
    FROM top_bottom_authors tba
    JOIN random_matching_authors rma ON tba.h5_index = rma.h5_index AND tba.subject = rma.subject
),
-- Step 4: Get works for matched random authors
random_author_works AS (
    SELECT DISTINCT wa.work_id AS id, w.doi, ma.random_subject AS subject, ma.random_h5_index AS h5_index
    FROM matched_authors ma
    JOIN work_authors wa ON wa.orcid = ma.random_orcid
    JOIN works w ON w.id = wa.work_id
),
-- Step 5: Join with work_citations to get citation numbers
random_work_citations AS (
    SELECT raw.id, wc.citations_number, raw.subject
    FROM random_author_works raw
    JOIN rolap.work_citations wc ON wc.doi = raw.doi
    WHERE wc.citations_number >= h5_index -- REMOVE
),
-- Step 6: Rank and select works for matched random authors
ranked_random_works AS (
    SELECT id, citations_number, subject,
           ROW_NUMBER() OVER (PARTITION BY subject ORDER BY substr(
                 id * 0.54534238371923827955579364758491,
                 length(id) + 2
           )) AS rank
    FROM random_work_citations
)
SELECT id, citations_number, subject
FROM ranked_random_works
WHERE rank <= 50;