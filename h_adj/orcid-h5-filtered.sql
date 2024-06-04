SELECT orcid, h5_index, adjusted_h5_index, subject, avg_subject_h5_index FROM rolap.orcid_h5_filtered
  ORDER BY h5_index DESC
  LIMIT 100;