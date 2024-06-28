-- Step 1: Select the top 50 authors per subject from orcid_h5_bottom
WITH top_bottom_authors AS (
    SELECT orcid, h5_index, subject, 
           ROW_NUMBER() OVER (PARTITION BY subject ORDER BY h5_index DESC) AS rn
    FROM rolap.orcid_h5_bottom
    WHERE h5_index IS NOT NULL -- LIMIT 200 INSTEAD
),
filtered_top_bottom_authors AS ( -- REMOVE
    SELECT orcid, h5_index, subject, rn -- REMOVE
    FROM top_bottom_authors -- REMOVE
    WHERE rn <= 40 -- REMOVE
),
-- Step 2: Select random authors from orcid_h5_filtered with matching h-index
random_matching_authors AS (
    SELECT orcid, h5_index, subject,
           ROW_NUMBER() OVER (PARTITION BY h5_index ORDER BY substr(orcid * 0.54534238371923827955579364758491, length(orcid) + 2)) AS rn
    FROM rolap.orcid_h5_filtered
    WHERE (h5_index, subject) IN (SELECT h5_index, subject FROM filtered_top_bottom_authors) -- CHANGE with top_bottom_authors
),
-- Step 3: Ensure 1-to-1 matching based on row number (rn)
matched_authors AS (
    SELECT tba.orcid AS bottom_orcid,
           tba.h5_index AS bottom_h5_index,
           tba.subject AS bottom_subject,
           rma.orcid AS random_orcid,
           rma.h5_index AS random_h5_index,
           rma.subject AS random_subject
    FROM filtered_top_bottom_authors tba -- CHANGE with top_bottom_authors
    JOIN random_matching_authors rma ON tba.h5_index = rma.h5_index AND tba.rn = rma.rn
),
-- Step 4: Count the h-index of cited journals (issns) for each author in top_bottom_authors
bottom_author_issn_hindex AS (
    SELECT work_authors.orcid,
           AVG(issn_subject_h5.h5_index) AS cited_journal_hindex
    FROM work_authors
    JOIN works ON work_authors.work_id = works.id
    JOIN work_references ON works.id = work_references.work_id
    JOIN rolap.works_issn_subject AS cited_work ON work_references.doi = cited_work.doi
    JOIN issn_subject_h5 ON cited_work.issn = issn_subject_h5.issn
    WHERE work_authors.orcid IN (SELECT bottom_orcid FROM matched_authors)
    GROUP BY work_authors.orcid
),
-- Step 4: Count the h-index of cited journals (issns) for each author in random_matching_authors
random_author_issn_hindex AS (
    SELECT work_authors.orcid,
           AVG(issn_subject_h5.h5_index) AS cited_journal_hindex
    FROM work_authors
    JOIN works ON work_authors.work_id = works.id
    JOIN work_references ON works.id = work_references.work_id
    JOIN rolap.works_issn_subject AS cited_work ON work_references.doi = cited_work.doi
    JOIN issn_subject_h5 ON cited_work.issn = issn_subject_h5.issn
    WHERE work_authors.orcid IN (SELECT random_orcid FROM matched_authors)
    GROUP BY work_authors.orcid
)
-- Final selection to compare the h-index of cited journals for both sets of authors
SELECT
    ma.bottom_orcid,
    ma.bottom_h5_index,
    ma.bottom_subject,
    bai.cited_journal_hindex AS avg_bottom_cited_journal_hindex,
    ma.random_orcid,
    ma.random_h5_index,
    ma.random_subject,
    rai.cited_journal_hindex AS avg_random_cited_journal_hindex
FROM matched_authors ma
LEFT JOIN bottom_author_issn_hindex bai ON ma.bottom_orcid = bai.orcid
LEFT JOIN random_author_issn_hindex rai ON ma.random_orcid = rai.orcid;
