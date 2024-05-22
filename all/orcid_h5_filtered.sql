--- Calculate h5-index for each ORCID taking into account only works that 
--- are published in the top 20 ISSN's for the relevant subject
CREATE INDEX IF NOT EXISTS rolap.work_citations_doi_idx ON work_citations (doi);
-- Index on DOI for efficient joining with work_citations table
CREATE INDEX IF NOT EXISTS rolap.filtered_works_orcid_h5_doi_idx ON filtered_works_orcid_h5 (doi);
-- Index on ORCID for efficient grouping and filtering in h5-index calculations
CREATE INDEX IF NOT EXISTS rolap.filtered_works_orcid_h5_orcid_idx ON filtered_works_orcid_h5 (orcid);

CREATE TABLE rolap.orcid_h5_filtered AS
WITH ranked_orcid_citations AS (
    SELECT filtered_works_orcid_h5.orcid, citations_number,
           ROW_NUMBER() OVER (
               PARTITION BY orcid ORDER BY citations_number DESC
           ) AS row_rank
    FROM rolap.work_citations
    INNER JOIN rolap.filtered_works_orcid_h5 ON rolap.filtered_works_orcid_h5.doi = rolap.work_citations.doi
),
eligible_ranks AS (
    SELECT orcid, row_rank
    FROM ranked_orcid_citations
    WHERE row_rank <= citations_number
)
SELECT orcid, MAX(row_rank) AS h5_index
FROM eligible_ranks
GROUP BY orcid;