-- Create common electronic and print ISSN lookup
-- TODO : change general to subject
CREATE TABLE rolap.works_issn_subject AS
    SELECT doi, Coalesce(works.issn_print, works.issn_electronic) AS issn, asjcs.subject_area_id as subject
    FROM works INNER JOIN works_asjcs ON works.id = works_asjcs.work_id
               INNER JOIN asjcs ON asjcs.id = works_asjcs.asjc_id
    WHERE issn is not null;
