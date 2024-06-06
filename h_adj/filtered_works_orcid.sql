-- Create a table with the the authors that have works in the top journals of each subject
CREATE TABLE rolap.filtered_works_orcid AS
SELECT DISTINCT wo.doi, wo.orcid as orcid, ws.subject as subject
FROM rolap.works_orcid wo
         INNER JOIN rolap.works_issn_subject ws ON wo.doi = ws.doi
         INNER JOIN rolap.top_issn_by_subject tp ON ws.issn = tp.issn
WHERE wo.orcid IS NOT NULL;