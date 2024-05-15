import pandas as pd
from scipy.stats import spearmanr, pearsonr, kendalltau
from sqlalchemy import create_engine

ROLAP_DATABASE_PATH = "rolap.db"


engine = create_engine(f'sqlite:///{ROLAP_DATABASE_PATH}')

query = """
WITH ranked_table1 AS (
    SELECT 
        orcid,
        h5_index,
        RANK() OVER (ORDER BY h5_index) AS rank1
    FROM 
        orcid_h5_filtered
),
ranked_table2 AS (
    SELECT 
        orcid,
        h5_index,
        RANK() OVER (ORDER BY h5_index) AS rank2
    FROM 
        orcid_h5
)
SELECT 
    r1.orcid,
    r1.rank1,
    r2.rank2
FROM 
    ranked_table1 r1
JOIN 
    ranked_table2 r2
ON 
    r1.orcid = r2.orcid;
"""

# Load data into a pandas DataFrame
df = pd.read_sql(query, engine)

# Calculate the Spearman rank correlation
correlation, p_value = spearmanr(df['rank1'], df['rank2'])

print(f'Spearman Rank Correlation: {correlation}')
print(f'P-value: {p_value}')

# Pearson correlation
correlation, p_value = pearsonr(df['rank1'], df['rank2'])
print(f'Pearson Correlation: {correlation}')
print(f'P-value: {p_value}')

# Kendall's tau
correlation, p_value = kendalltau(df['rank1'], df['rank2'])
print(f'Kendall Tau: {correlation}')
print(f'P-value: {p_value}')