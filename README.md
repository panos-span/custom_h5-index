# Custom H5-Index Implementation on Alexandria3k

## Overview

This repository contains the implementation of a custom H5-Index, JIF-Index, and EigenFactor Index on the Alexandria3k
platform. The purpose of this project is to address the limitations of the traditional H-Index by incorporating journal
quality and subject specificity into the calculation of H-Indexes. This repository is organized into three main
folders: `EigenFactor`, `JIF`, and `H5`, each containing the respective implementation and analysis.

## Thesis Summary

### Research Questions

This thesis aims to answer the following key research questions to evaluate the proposed H-Index metrics:

1. What is the correlation between traditional H-Index values and the proposed H-Index metrics that account for journal
   quality?
2. How do citation practices differ between top authors publishing in low-quality journals and authors publishing in
   high-quality journals?
3. How do citation patterns differ between hyperprolific researchers and regular researchers across different subject
   areas?

By addressing these research questions, this thesis seeks not only to develop and validate improved H-Index calculations
that incorporate journal quality, but also to provide insights into the citation practices and patterns of researchers
across different subjects, thus contributing to a more complete understanding of scholarly impact.

## Features

- **Data Collection and Preparation**: Utilize Alexandria3k to extract and prepare publication data from the
  Crossref-2024 dataset.
- **ROLAP Analysis**: Perform ROLAP analysis to handle large-scale bibliometric data efficiently.
- **Custom H5-Index Calculation**: Implement custom SQL queries to calculate the H5-Index based on the top 20% of
  journals by H5-Index, JIF, and EigenFactor within specific subjects.
- **Statistical Analysis**: Calculate Pearson, Spearman, and Kendall tau correlations to compare traditional and
  adjusted H-Indexes.
- **Citation Network Analysis**: Examine the clustering coefficients of citation networks to understand the
  interconnectedness of highly cited works.

## Methodology

### Data Collection

- Use Alexandria3k to extract publication and citation data from the Crossref-2024 dataset.
- Prepare the data for processing by filtering for relevant records and associating works with their respective ORCID
  identifiers and subject areas.

### Data Preparation

- Create tables for storing filtered works, work citations, and journal impact factors.
- Ensure data consistency and completeness by handling missing values and standardizing journal identifiers.

### ROLAP Analysis

- Implement SQL queries for efficient ROLAP analysis.
- Calculate the H5-Index by partitioning data by subject and ranking works based on citation counts.

### Custom H5-Index Calculation

- Identify the top 20% of journals by H5-Index, JIF, and EigenFactor within each subject.
- Calculate the custom H5-Index by considering only works published in these top journals.
- Adjust the H5-Index based on average H5-Indexes within each subject to account for journal quality.

### Statistical Analysis

- Compare traditional and adjusted H-Indexes using rank order correlations (Pearson, Spearman, Kendall tau).
- Analyze the differences in citation patterns and clustering coefficients between traditional and adjusted H-Indexes.

## Results

The results demonstrate that the adjusted H5-Indexes, JIF-Indexes, and EigenFactor-Indexes are significantly correlated
with the traditional H-Index, indicating a strong positive relationship. However, the adjusted indexes provide
additional insights by accounting for journal quality and subject-specific citation practices, leading to a more nuanced
assessment of scholarly impact. The analysis reveals significant differences in citation practices between top authors
publishing in lower-tier journals and those publishing in top-tier journals. Additionally, hyperprolific researchers
exhibit more interconnected citation networks compared to regular researchers, highlighting the importance of
considering citation practices and network structures in bibliometric evaluations.

## Folder Structure

### `EigenFactor`

This folder contains the implementation and analysis of the EigenFactor-adjusted H-Index. The EigenFactor metric
evaluates the quality of journals based on their influence and impact. The implementation includes:

- Data extraction from the Alexandria3k tool.
- Calculation of the EigenFactor-adjusted H-Index for top authors.
- Analysis of citation practices and patterns based on the EigenFactor ranking.
- Comparison of top authors publishing in lower-tier journals with random authors publishing in top-tier journals.

### `JIF`

This folder contains the implementation and analysis of the JIF (Journal Impact Factor)-adjusted H-Index. The JIF is a
widely used metric that measures the average number of citations received by articles published in a journal. The
implementation includes:

- Data extraction from the Alexandria3k tool.
- Calculation of the JIF-adjusted H-Index authors.
- Analysis of citation practices and patterns based on the JIF ranking.
- Comparison of top authors publishing in lower-tier journals with random authors publishing in top-tier journals.

### `H5`

This folder contains the implementation and analysis of the H5-Index-adjusted H-Index. The H5-Index is a variant of the
H-Index that measures the productivity and impact of researchers based on the number of citations received in the last
five years. The implementation includes:

- Data extraction from the Alexandria3k tool.
- Calculation of the H5-Index-adjusted H-Index for authors.
- Analysis of citation practices and patterns based on the H5-Index ranking.
- Comparison of top authors publishing in lower-tier journals with random authors publishing in top-tier journals.
