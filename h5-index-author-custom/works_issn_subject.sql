-- Create common electronic and print ISSN lookup

CREATE TABLE rolap.works_issn_subject AS
SELECT doi, Coalesce(works.issn_print, works.issn_electronic) AS issn, work_subjects.name
FROM works
WHERE issn is not null;
