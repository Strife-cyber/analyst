// algorithms_data.dart

const List<Map<String, String>> algorithmsUsed = [
  {
    'name': 'Data Cleaning',
    'purpose':
        'Prepare raw data for analysis by removing inconsistencies, missing values, and duplicates.',
    'function':
        'Cleanse the dataset to ensure the data is accurate and complete.',
    'steps': '1. Remove Missing Data\n2. Remove Duplicates\n3. Outlier Removal',
    'example':
        'In a student dataset, remove rows with missing grades, duplicate student entries, or anomalous data (like negative marks).',
  },
  {
    'name': 'Data Aggregation',
    'purpose':
        'Summarize data by grouping it based on categories, then applying aggregation functions like sum, mean, or count.',
    'function':
        'Group similar data points and aggregate them for a concise overview.',
    'steps':
        '1. Group by Categorical Variables\n2. Calculate Summary Statistics',
    'example':
        'In a meal dataset, group meals by type (e.g., "vegetarian") and calculate the average calories, average price, etc.',
  },
  {
    'name': 'Min-Max Normalization',
    'purpose':
        'Rescale numerical data to fit within a specific range or distribution.',
    'function':
        'Prepare numerical data for better comparison or for use in machine learning algorithms.',
    'steps': '1. Min-Max Normalization\n2. Z-Score Standardization',
    'example':
        'Normalize the "price" field of a meal dataset so that all prices are between 0 and 1.',
  },
  {
    'name': 'Z-Score Standardization',
    'purpose':
        'Rescale numerical data to fit a specific range or distribution.',
    'function':
        'Prepare numerical data for better comparison or for use in machine learning algorithms.',
    'steps': 'Z-Score Standardization',
    'example':
        'Normalize the "price" field of a meal dataset so that all prices are between 0 and 1.',
  }
];
