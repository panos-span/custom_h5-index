CREATE TABLE rolap.bottom_filtered_works_orcid AS
SELECT DISTINCT
    wo.doi,
    wo.orcid,
    ws.subject
FROM rolap.works_orcid AS wo
INNER JOIN rolap.works_issn_subject AS ws ON wo.doi = ws.doi
INNER JOIN rolap.bottom_issn_by_subject AS tp ON ws.issn = tp.issn
WHERE wo.orcid IS NOT NULL;
