import pandas as pd
from scipy.stats import spearmanr, pearsonr, kendalltau, somersd, weightedtau, rankdata
from sqlalchemy import create_engine
from itertools import permutations
import numpy as np

ROLAP_DATABASE_PATH = "rolap.db"


engine = create_engine(f'sqlite:///{ROLAP_DATABASE_PATH}')

query = """
WITH ranked_table1 AS (
    SELECT 
        orcid,
        h5_index,
        RANK() OVER (ORDER BY h5_index) AS rank1
    FROM 
        orcid_h5
),
ranked_table2 AS (
    SELECT 
        orcid,
        h5_index,
        RANK() OVER (ORDER BY h5_index) AS rank2
    FROM 
        orcid_h5_filtered
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


# Rank Biased Overlap (RBO) Implementation
def rbo(list1, list2, p=0.9):
    """
    Calculate Rank Biased Overlap (RBO) score for two ranked lists.
    """
    s, t = list1, list2
    sl, tl = len(s), len(t)
    if sl > tl:
        s, t = t, s
        sl, tl = tl, sl
    score = 0.0
    for d in range(sl):
        score += (s[d] == t[d]) * (p ** d) / (d + 1)
    return (1 - p) * score + (p ** sl) * score * (1 / sl) / (1 - p)


# RBO for the full lists
rbo_score = rbo(df['rank1'], df['rank2'])
print(f'Rank Biased Overlap (RBO): {rbo_score}')

# print SOMERS' D
somersd_score = somersd(df['rank1'], df['rank2'])
print(f'Somers\' D: {somersd_score}')
