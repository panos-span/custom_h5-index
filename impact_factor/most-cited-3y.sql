-- Most cited article in the period 2019-2021

SELECT
    doi,
    Count(*)
FROM work_references
GROUP BY doi
ORDER BY Count(*) DESC
LIMIT 10;
