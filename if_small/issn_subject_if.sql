-- Calculate impact-factor for each ISSN

-- Create indexes for subjects
CREATE INDEX IF NOT EXISTS rolap.works_issn_subject_doi_idx ON works_issn_subject(doi);
CREATE INDEX IF NOT EXISTS rolap.works_issn_subject_issn_idx ON works_issn_subject(issn);
CREATE INDEX IF NOT EXISTS rolap.works_issn_subject_subject_idx ON works_issn_subject(subject);
CREATE INDEX IF NOT EXISTS rolap.work_citations_doi_idx ON work_citations(doi);


-- Calculate the impact factor for each ISSN and Subject
CREATE TABLE rolap.issn_subject_if AS
    WITH publication_data AS (
        SELECT issn, subject, COUNT(*) AS total_publications
        FROM rolap.works_issn_subject
        WHERE published_year IN (2021)  -- Modify based on your DBMS's date functions
        GROUP BY issn, subject
    ),
    citation_data AS (
        SELECT issn, subject, COUNT(*) AS total_citations
        FROM rolap.work_citations
        INNER JOIN rolap.works_issn_subject ON rolap.work_citations.doi = rolap.works_issn_subject.doi
        WHERE cited_year IN (2020, 2019) -- Last two years
        GROUP BY issn, subject
    ),
    impact_factors AS (
        SELECT publication_data.issn, publication_data.subject,
            CASE
                WHEN total_publications > 0 THEN CAST(total_citations AS FLOAT) / total_publications
                ELSE 0
            END AS impact_factor
        FROM publication_data
            LEFT JOIN citation_data ON publication_data.issn = citation_data.issn AND publication_data.subject = citation_data.subject
    )
SELECT issn, subject, impact_factor
FROM impact_factors
ORDER BY issn, subject, impact_factor DESC;
