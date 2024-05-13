-- Create common electronic and print ISSN lookup

CREATE TABLE rolap.works_issn_subject AS
    SELECT doi, Coalesce(works.issn_print, works.issn_electronic) AS issn, asjc_general_fields.id as subject
    FROM works INNER JOIN works_asjcs ON works.id = works_asjcs.work_id
               INNER JOIN asjcs ON asjcs.id = works_asjcs.asjc_id
               INNER JOIN asjc_general_fields ON asjc_general_fields.id = asjcs.general_field_id
    WHERE issn is not null;
