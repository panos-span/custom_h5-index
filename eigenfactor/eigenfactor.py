import pandas as pd
import numpy as np
import sqlite3

# Read the text file and replace '|' with ','
input_file = 'get_citation_network copy.txt'
output_file = 'get_citation_network.csv'

with open(input_file, 'r') as file:
    file_content = file.read()

file_content = file_content.replace('|', ',')

# Write the modified content to a CSV file
with open(output_file, 'w') as file:
    file.write(file_content)

# Load the citation network
df = pd.read_csv('get_citation_network.csv', header=None,
                 names=['citing_issn', 'cited_issn', 'subject', 'citation_count'])

# Aggregate citation counts to avoid duplicates
df_aggregated = df.groupby(['cited_issn', 'citing_issn', 'subject'], as_index=False).sum()

# Create a pivot table to form the citation matrix by subject
subject_groups = df_aggregated.groupby('subject')
eigenfactor_results = []

for subject, group in subject_groups:
    citation_matrix = group.pivot(index='cited_issn', columns='citing_issn', values='citation_count').fillna(0)

    # Ensure the matrix is square by adding missing columns
    all_issns = set(citation_matrix.index).union(set(citation_matrix.columns))
    citation_matrix = citation_matrix.reindex(index=all_issns, columns=all_issns, fill_value=0)

    # Normalize the matrix to create a transition matrix
    column_sums = citation_matrix.sum(axis=0)
    transition_matrix = citation_matrix.div(column_sums, axis=1).fillna(0)  # Fill NaN to handle division by zero

    # Handle dangling nodes by redistributing to all nodes
    article_vector = citation_matrix.sum(axis=1) / citation_matrix.values.sum()
    dangling_nodes = column_sums == 0
    transition_matrix.loc[:, dangling_nodes] = article_vector.values[:, None]  # Convert to numpy array before indexing

    # Initialize scores (PageRank-like)
    num_journals = transition_matrix.shape[0]
    eigenfactor_scores = np.ones(num_journals) / num_journals

    # Damping factor
    damping_factor = 0.85
    random_jump = (1 - damping_factor) / num_journals

    # Define the matrix P
    P = damping_factor * transition_matrix + (1 - damping_factor) * article_vector.values[:, None]

    # Iterate until convergence
    iteration = 0
    max_iterations = 100
    tolerance = 1e-6
    delta = 1
    while delta > tolerance and iteration < max_iterations:
        new_scores = P.dot(eigenfactor_scores)
        delta = np.linalg.norm(new_scores - eigenfactor_scores, 1)  # Using L1 norm for convergence check
        eigenfactor_scores = new_scores
        iteration += 1

    # Normalize eigenfactor scores
    total_weighted_citations = (transition_matrix.dot(eigenfactor_scores)).sum()
    eigenfactor_scores_normalized = 100 * eigenfactor_scores / total_weighted_citations

    # Log transform the normalized Eigenfactor scores
    log_normalized_eigenfactor_scores = np.log1p(eigenfactor_scores_normalized)  # Use log1p to handle log(0)

    # Normalize by the average score to get the final normalized Eigenfactor score
    final_normalized_eigenfactor_scores = log_normalized_eigenfactor_scores / log_normalized_eigenfactor_scores.mean()

    # Create a DataFrame for the scores
    eigenfactor_df = pd.DataFrame({
        'issn': citation_matrix.index,
        'subject': subject,
        'eigenfactor_score': final_normalized_eigenfactor_scores
    })

    eigenfactor_results.append(eigenfactor_df)

# Combine results from all subjects
eigenfactor_combined_df = pd.concat(eigenfactor_results, ignore_index=True)

# Save the results to a CSV
eigenfactor_combined_df.to_csv('eigenfactor_scores.csv', index=False)

# Create table in SQLite database
conn = sqlite3.connect('impact.db')

# Drop the table if it already exists
cursor = conn.cursor()
cursor.execute('DROP TABLE IF EXISTS eigenfactor_scores')

# Create a new table for the data
cursor.execute('''
    CREATE TABLE IF NOT EXISTS eigenfactor_scores (
        ISSN TEXT,
        SUBJECT TEXT,
        eigenfactor_score REAL,
        PRIMARY KEY (issn, subject)
    )
''')

# Insert data into the table
eigenfactor_combined_df.to_sql('eigenfactor_scores', conn, if_exists='replace', index=False)

# Commit the changes and close the connection
conn.commit()

print("Eigenfactor scores successfully calculated and saved.")

# Close the connection
conn.close()
