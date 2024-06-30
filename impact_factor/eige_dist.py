import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import sqlite3

# Read from the sqlite

db = sqlite3.connect("rolap.db")

df = pd.read_sql_query("SELECT impact_factor,subject FROM impact_factor", db)

# Print the percentiles of the eigenfactor scores
percentiles = [0, 0.25, 0.5, 0.7, 0.75, 0.9, 0.99, 1]

for p in percentiles:
    percentile_value = df["impact_factor"].quantile(p)
    print(f"{p*100:.0f}th percentile: {percentile_value:.2f}")

print(df.max())

# Save the box plot
df.value_counts("subject").plot(kind="bar")

# Save the box plot
plt.figure(figsize=(12, 6))

sns.boxplot(x="subject", y="impact_factor", data=df)
plt.title("impact_factor Score Distribution by Subject")
plt.xticks(rotation=45)
plt.tight_layout()

plt.savefig("bb.png")

db.close()
