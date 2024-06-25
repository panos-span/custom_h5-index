-- Count the number of authors with h5_index greater than 60
SELECT COUNT(*) AS authors_with_h5_index_over_10 
FROM rolap.orcid_h5_bottom 
WHERE h5_index > 8;
