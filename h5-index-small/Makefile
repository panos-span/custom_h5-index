#
# Calculate h5-index of authors but only take account works published by popular journals 
# (e.g., Nature, Science, PNAS, etc.)
# based on each work subject of the author.
#

export MAINDB?=h5
export DEPENDENCIES=populate journal-names asjcs link-works-asjcs

include ../common/Makefile

# Populate database with required details for past five years
populate: $(CROSSREF_DIR)
	# Populate database with DOIs of works and their references
	$(TIME) $(A3K) --debug progress populate "$(MAINDB).db" crossref "$(CROSSREF_DIR)" \
	  --sample 'random.random() < 0.2' \
	  --columns works.id works.doi work_subjects.name \
	    work_references.doi work_references.work_id \
		works.issn_print works.issn_electronic work_subjects.work_id \
	    work_authors.work_id work_authors.orcid \
	  --row-selection 'works.published_year BETWEEN 2017 AND 2021'
	touch $@

clear:
	make clean
	rm .* *.db journal-names populate 2>/dev/null
	rm -rf simple-rolap
