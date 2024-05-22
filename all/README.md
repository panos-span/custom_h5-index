# Custom H5 index claculator for authors

This example shows how to create a custom H5 index calculator for authors, taking into account
only the papers that are published in popular journals and as such are considered to be more
influential and trustworthy.
This way the H5 index is calculated only for the papers that are considered to be more important
and it is a more accurate representation of the author's influence in the scientific community.

The order needed to run the example is the following:
1) Initialize the data [Makefile](Makefile)
2) Create a table that has ORCIDs associated with each work [works_orcid.sql](works_orcid.sql)
3) Calculate the Count number of citations to each work [works_citations.sql](works_citations.sql)
4) Create common electronic and print ISSN lookup with subject [works_issn_subject.sql](works_issn_subject.sql)
5) Calculate the Journal H5 index with respect of the subject area of the author [calculate_issn-h5.sql](calculate_issn-h5.sql)
6) Get the top 20 journals based on h5 index per subject area [top_issns.sql](top_issns.sql)
7) Calculate the Custom Author H5 index that only takes into account the papers published in popular journals [filtered_works_orcid_h5.sql](filtered_works_orcid_h5.sql) [calculate_orcid-h5.sql](calculate_orcid-h5.sql)
8) Proceed to work with the citation graph. Files: [citation-graph.py](citation-graph.py), [random_top_works.sql](random_top_works.sql), [random_other_works.sql](random_other_works.sql)

## Requirements

The above runs with tests using RDBUnit and the simple rolap for effective processing of the data.