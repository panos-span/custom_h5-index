-- Create a table with the the authors that have works in the top journals of each subject
-- TODO: Change the filtered with top_authors
CREATE TABLE rolap.filtered_works_orcid_h5 AS
SELECT DISTINCT wo.doi, wo.orcid as orcid
FROM rolap.works_orcid wo
         INNER JOIN rolap.works_issn_subject ws ON wo.doi = ws.doi
         INNER JOIN rolap.top_issn_by_subject_h5 tp ON ws.issn = tp.issn
WHERE wo.orcid IS NOT NULL;