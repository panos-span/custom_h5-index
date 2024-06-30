import pandas as pd
import sqlite3
from tqdm import tqdm

# Define the input file path and SQLite database path
input_file = "get_issn_subject.txt"
db_file = "h5.db"

# Read the input file
data = pd.read_csv(input_file, sep="|", header=None, names=["ISSN", "Code"])

# print how many issn have no code (number)
print("Number of ISSN with no code:", data["Code"].isnull().sum())

# Drop rows with missing values
data = data.dropna()

# Select only the ISSN and Subject columns
filtered_data = data[["ISSN", "Code"]]

# Connect to the SQLite database (or create it if it doesn't exist)
conn = sqlite3.connect(db_file)
cursor = conn.cursor()

# Drop the table if it already exists
cursor.execute("DROP TABLE IF EXISTS journal_data")

# Create a new table for the data with a composite primary key
cursor.execute(
    """
    CREATE TABLE IF NOT EXISTS journal_data (
        ISSN TEXT,
        Subject TEXT,
        PRIMARY KEY (ISSN, Subject)
    )
"""
)

for index, row in tqdm(filtered_data.iterrows(), total=filtered_data.shape[0]):
    cursor.execute(
        """
        INSERT OR IGNORE INTO journal_data (ISSN, Subject) VALUES (?, ?)
    """,
        (row["ISSN"], row["Code"]),
    )

# Commit the changes and close the connection
conn.commit()
conn.close()

print("Data successfully inserted into", db_file)
