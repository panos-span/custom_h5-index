-- Count the number of authors with h5_index greater than 60
SELECT COUNT(*) AS authors_with_h5_index_over_60 
FROM rolap.orcid_h5_filtered 
WHERE h5_index > 60;
