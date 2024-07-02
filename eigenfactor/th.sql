SELECT
    COUNT(CASE WHEN h5_index > 40 THEN 1 END) AS authors_with_h5_index_over_40,
    COUNT(CASE WHEN h5_index > 50 THEN 1 END) AS authors_with_h5_index_over_50,
    COUNT(CASE WHEN h5_index > 60 THEN 1 END) AS authors_with_h5_index_over_60
FROM
    rolap.orcid_h5_filtered
