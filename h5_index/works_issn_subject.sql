-- Create common electronic and print ISSN lookup

CREATE TABLE rolap.works_issn_subject AS
    SELECT id, doi, Coalesce(works.issn_print, works.issn_electronic) AS issn, journal_data.Subject as subject
    FROM works INNER JOIN journal_data ON journal_data.ISSN = Coalesce(works.issn_print, works.issn_electronic)
    WHERE issn is not null AND journal_data.Subject IS NOT NULL;
