# Custom H5-Index Implementation on Alexandria3k

## Overview
This project involves the implementation of a custom H5-Index calculation using the Alexandria3k tool and a relational OLAP (ROLAP) analysis framework. The custom H5-Index is designed to provide a more accurate assessment of a researcher's scholarly impact by incorporating subject-specific journal rankings and adjusting for journal quality metrics such as the H5-Index and Journal Impact Factor (JIF).

## Objectives
- Develop custom H5-Index metrics that account for the quality of the journals in which a researcher's works are published.
- Evaluate the effectiveness of the adjusted H5-Indexes by comparing them with the traditional H-Index.
- Analyze the impact of journal quality on the calculation of scholarly impact metrics.

## Features
- **Data Collection and Preparation**: Utilize Alexandria3k to extract and prepare publication data from the Crossref-2024 dataset.
- **ROLAP Analysis**: Perform ROLAP analysis to handle large-scale bibliometric data efficiently.
- **Custom H5-Index Calculation**: Implement custom SQL queries to calculate the H5-Index based on the top 20% of journals by H5-Index and JIF within specific subjects.
- **Statistical Analysis**: Calculate Pearson, Spearman, and Kendall tau correlations to compare traditional and adjusted H-Indexes.
- **Citation Network Analysis**: Examine the clustering coefficients of citation networks to understand the interconnectedness of highly cited works.

## Methodology
1. **Data Collection**:
    - Use Alexandria3k to extract publication and citation data from the Crossref-2024 dataset.
    - Prepare the data for processing by filtering for relevant records and associating works with their respective ORCID identifiers and subject areas.

2. **Data Preparation**:
    - Create tables for storing filtered works, work citations, and journal impact factors.
    - Ensure data consistency and completeness by handling missing values and standardizing journal identifiers.

3. **ROLAP Analysis**:
    - Implement SQL queries for efficient ROLAP analysis.
    - Calculate the H5-Index by partitioning data by subject and ranking works based on citation counts.

4. **Custom H5-Index Calculation**:
    - Identify the top 20% of journals by H5-Index and JIF within each subject.
    - Calculate the custom H5-Index by considering only works published in these top journals.
    - Adjust the H5-Index based on average H5-Indexes within each subject to account for journal quality.

5. **Statistical Analysis**:
    - Compare traditional and adjusted H-Indexes using rank order correlations (Pearson, Spearman, Kendall tau).
    - Analyze the differences in citation patterns and clustering coefficients between traditional and adjusted H-Indexes.

## Results
The results demonstrate that the adjusted H5-Indexes are significantly correlated with the traditional H-Index, indicating a strong positive relationship. However, the adjusted H5-Indexes provide additional insights by accounting for journal quality and subject-specific citation practices, leading to a more nuanced assessment of scholarly impact.

## Implications
- **For Researchers**: Publishing in high-quality journals enhances the visibility and recognition of their work, leading to a more accurate assessment of their impact.
- **For Practitioners**: Incorporating journal quality metrics into evaluation criteria ensures a more comprehensive and meaningful evaluation of researchers' contributions.
- **Future Research**: Further research into advanced H-Index variants is needed to address issues such as self-citation and hyperauthorship.

## Contributing
Contributions to this project are welcome. Please fork the repository and submit pull requests with any improvements or new features.

## License
This project is licensed under the Apache 2.0 License. See the LICENSE file for details.

## Contact
For any questions or suggestions, please open an issue or contact the project maintainers.
