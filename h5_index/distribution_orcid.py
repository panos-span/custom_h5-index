import sqlite3
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Step 1: Connect to the SQLite database
db_path = 'rolap.db'  # Replace with the path to your database
conn = sqlite3.connect(db_path)

# Step 2: Execute the SQL query to retrieve the data
query = """
SELECT orcid, h5_index, subject
FROM orcid_h5_filtered
ORDER BY h5_index DESC
"""
df = pd.read_sql_query(query, conn)

# Step 3: Process the data to get the distribution of h5_index values
h5_distribution = df['h5_index'].value_counts().sort_index()

# Step 4: Calculate percentiles
percentiles = [0.2, 0.5, 0.75]
percentile_values = np.percentile(df['h5_index'], [p * 100 for p in percentiles])

# Step 5: Visualize the distribution
plt.figure(figsize=(10, 6))
h5_distribution.plot(kind='bar')
plt.title('Distribution of h5_index Values')
plt.xlabel('h5_index')
plt.ylabel('Frequency')
plt.grid(True)

# Annotate percentiles
for percentile, value in zip(percentiles, percentile_values):
    plt.axvline(x=value, color='r', linestyle='--')
    plt.text(value, plt.ylim()[1]*0.9, f'{percentile*100:.0f}th percentile: {value:.2f}', color='r')

plt.show()

# Step 6: Save the plot to a file
plt.savefig('reports/h5_index_distribution.png')

# Close the database connection
conn.close()
