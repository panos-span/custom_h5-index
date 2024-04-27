SELECT orcid, impact_factor FROM rolap.orcid_if_filtered
  ORDER BY impact_factor DESC
  LIMIT 100;