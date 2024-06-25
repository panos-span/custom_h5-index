CREATE TABLE rolap.bottom_issn_by_subject AS
WITH ranked_issns AS (
    SELECT issn, subject, eigenfactor_score,
           ROW_NUMBER() OVER (PARTITION BY subject ORDER BY eigenfactor_score ASC) AS rank,
           COUNT(*) OVER (PARTITION BY subject) AS total_journals
    FROM eigenfactor_scores
),
cutoff_ranks AS (
    SELECT subject, ROUND(0.05 * total_journals + 0.4999) AS cutoff_rank
    FROM (SELECT subject, MAX(rank) AS total_journals FROM ranked_issns GROUP BY subject)
)
SELECT r.issn, r.subject
FROM ranked_issns r
JOIN cutoff_ranks c ON r.subject = c.subject
WHERE r.rank <= c.cutoff_rank;
