CREATE TABLE rolap.random_bottom_works AS
WITH top_bottom_authors AS (
    SELECT orcid, h5_index, subject,
           ROW_NUMBER() OVER (PARTITION BY subject ORDER BY h5_index DESC) AS rn
    FROM rolap.orcid_h5_bottom
    WHERE h5_index IS NOT NULL
),
matched_bottom_authors AS (
    SELECT tba.orcid AS bottom_orcid,
           tba.h5_index AS bottom_h5_index,
           tba.subject AS bottom_subject
    FROM top_bottom_authors tba
    WHERE tba.rn <= 50
),
bottom_author_works AS (
    SELECT DISTINCT wa.work_id AS id, w.doi, mba.bottom_subject AS subject, mba.bottom_h5_index AS h5_index
    FROM matched_bottom_authors mba
    JOIN work_authors wa ON wa.orcid = mba.bottom_orcid
    JOIN works w ON w.id = wa.work_id
),
bottom_work_citations AS (
    SELECT baw.id, wc.citations_number, baw.subject
    FROM bottom_author_works baw
    JOIN rolap.work_citations wc ON wc.doi = baw.doi
),
ranked_bottom_works AS (
    SELECT id, citations_number, subject,
           ROW_NUMBER() OVER (PARTITION BY subject ORDER BY substr(
                 id * 0.54534238371923827955579364758491,
                 length(id) + 2
           )) AS rank
    FROM bottom_work_citations
)
SELECT id, citations_number, subject
FROM ranked_bottom_works
WHERE rank <= 50;
