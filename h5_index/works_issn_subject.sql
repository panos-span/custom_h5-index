-- Create common electronic and print ISSN lookup

CREATE TABLE rolap.works_issn_subject AS
SELECT
    id,
    doi,
    journal_data.subject,
    Coalesce(works.issn_print, works.issn_electronic)
        AS issn
FROM works INNER JOIN journal_data
    ON
        journal_data.issn = Coalesce(works.issn_print, works.issn_electronic)
WHERE issn IS NOT null AND journal_data.subject IS NOT null;
