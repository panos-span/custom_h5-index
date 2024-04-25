-- Create a table with the filtered works and their ORCID

CREATE TABLE rolap.filtered_works_orcid AS
SELECT DISTINCT w.doi, wa.orcid as orcid
FROM works w
         INNER JOIN work_authors wa ON w.id = wa.work_id
         INNER JOIN work_subjects ws ON w.id = ws.work_id
         INNER JOIN rolap.top_issn_by_subject tp ON ws.name = tp.subject
    AND Coalesce(w.issn_print, w.issn_electronic) = tp.issn
WHERE wa.orcid IS NOT NULL;