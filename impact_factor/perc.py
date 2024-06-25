

# Get percentiles of numeric lists
import numpy as np

# Define a list of values
values_1 = [10,9.5,8,7,6]
values_2 = [12,11,10,9,8,7.5]
values_3 = [2,1,1,1]

all_values = [values_1, values_2, values_3]

# Calculate percentiles
percentiles = [0.2, 0.5]

for values in all_values:
    # Perform the calculation
    percentile_values = np.percentile(values, [p * 100 for p in percentiles])

    # Output the results
    for percentile, value in zip(percentiles, percentile_values):
        print(f'{percentile*100:.0f}th percentile: {value:.2f}')
