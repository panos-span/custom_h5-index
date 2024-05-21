CREATE INDEX IF NOT EXISTS rolap.issn_h5_issn_idx ON issn_subject_h5(issn);
CREATE INDEX IF NOT EXISTS rolap.issn_h5_h5_index_idx ON issn_subject_h5(h5_index);

CREATE INDEX IF NOT EXISTS journal_names_iss_print_idx
  ON journal_names(issn_print);

CREATE INDEX IF NOT EXISTS journal_names_iss_eprint_idx
  ON journal_names(issn_eprint);

SELECT title, asjc_subject_areas.name, h5_index FROM rolap.issn_subject_h5 LEFT JOIN journal_names
  ON rolap.issn_subject_h5.issn = journal_names.issn_print
    OR rolap.issn_subject_h5.issn = journal_names.issn_eprint
  LEFT JOIN asjc_subject_areas ON subject = asjc_subject_areas.id
  WHERE h5_index is not null AND title is not null
  ORDER BY h5_index DESC, title ASC
  LIMIT 20;
