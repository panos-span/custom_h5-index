-- Create common electronic and print ISSN lookup

CREATE TABLE rolap.works_issn_subject AS
    SELECT doi, Coalesce(works.issn_print, works.issn_electronic) AS issn, work_subjects.name as subject, published_year
    FROM works INNER JOIN work_subjects ON works.id = work_subjects.work_id
    WHERE issn is not null;
