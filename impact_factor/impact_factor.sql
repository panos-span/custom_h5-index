-- Calculate the journal impact factor

CREATE TABLE rolap.impact_factor AS
SELECT
    rolap.publications.subject,
    publications_number,
    Replace(publications.issn, '-', '') AS issn,
    Coalesce(citations_number, 0) AS citations_number,
    Cast(Coalesce(citations_number, 0) AS FLOAT) / publications_number
        AS impact_factor
FROM rolap.publications
LEFT JOIN rolap.citations ON rolap.citations.issn = rolap.publications.issn
WHERE publications_number > 0
GROUP BY Replace(publications.issn, '-', ''), rolap.publications.subject;
