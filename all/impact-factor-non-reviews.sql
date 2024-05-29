-- Impact factor of non-review journals

SELECT issn, title, asjc_subject_areas.name, impact_factor
  FROM rolap.impact_factor_titles
  LEFT JOIN asjc_subject_areas
    ON subject = asjc_subject_areas.id
  WHERE NOT title LIKE '%reviews%'
  ORDER BY impact_factor DESC LIMIT 10;