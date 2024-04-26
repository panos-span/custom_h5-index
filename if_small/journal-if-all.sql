CREATE INDEX IF NOT EXISTS rolap.issn_if_impact_factor_idx ON issn_subject_if(issn);
CREATE INDEX IF NOT EXISTS rolap.issn_if_impact_factor_idx ON issn_subject_if(impact_factor);

CREATE INDEX IF NOT EXISTS journal_names_iss_print_idx
  ON journal_names(issn_print);

CREATE INDEX IF NOT EXISTS journal_names_iss_eprint_idx
  ON journal_names(issn_eprint);

SELECT title, subject, impact_factor FROM rolap.issn_subject_if LEFT JOIN journal_names
  ON rolap.issn_subject_if.issn = journal_names.issn_print
    OR rolap.issn_subject_if.issn = journal_names.issn_eprint
  WHERE impact_factor is not null AND title is not null
  ORDER BY impact_factor DESC, title ASC;
