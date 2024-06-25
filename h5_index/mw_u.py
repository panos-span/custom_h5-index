import numpy as np
from scipy.stats import mannwhitneyu


def calculate_medians_and_mann_whitney(file_top, file_other):
    top_data = np.genfromtxt(file_top, delimiter='\t', dtype=None, encoding=None, names=('subject', 'clustering'))
    other_data = np.genfromtxt(file_other, delimiter='\t', dtype=None, encoding=None, names=('subject', 'clustering'))

    subjects = set(top_data['subject']).union(other_data['subject'])

    results = []
    for subject in subjects:
        top_subject = top_data[top_data['subject'] == subject]['clustering']
        other_subject = other_data[other_data['subject'] == subject]['clustering']

        median_top = np.median(top_subject) if len(top_subject) > 0 else float('nan')
        median_other = np.median(other_subject) if len(other_subject) > 0 else float('nan')

        if len(top_subject) > 0 and len(other_subject) > 0:
            u_statistic, p_value = mannwhitneyu(top_subject, other_subject, alternative='two-sided')
        else:
            u_statistic, p_value = float('nan'), float('nan')

        results.append((subject, median_top, median_other, u_statistic, p_value))

    for result in results:
        print(f"Subject: {result[0]}, Median Top: {result[1]}, Median Other: {result[2]}, U-Statistic: {result[3]}, P-Value: {result[4]}")
        if result[4] < 0.001:
            print("The difference is statistically significant with P < 0.001")
        else:
            print("The difference is not statistically significant with P < 0.001")
            
calculate_medians_and_mann_whitney(
    "reports/graph-top-h5.txt",
    "reports/graph-other-top-h5.txt"
)

#calculate_medians_and_mann_whitney(
#    "reports/graph-bottom.txt",
#    "reports/graph-other.txt"
#)