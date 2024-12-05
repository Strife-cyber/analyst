import 'dart:math';

class DataScaler {
  /// Min-Max Normalization: Rescales data to the range [0, 1].
  static List<Map<String, dynamic>> minMaxNormalize(
      List<Map<String, dynamic>> dataset, String field) {
    // Extract numerical values of the given field
    List<num> values = dataset.map((item) => item[field] as num).toList();

    // Find the minimum and maximum values
    num minValue = values.reduce((a, b) => a < b ? a : b);
    num maxValue = values.reduce((a, b) => a > b ? a : b);

    // Normalize the data
    for (var item in dataset) {
      var value = item[field];
      item[field] = (value - minValue) / (maxValue - minValue);
    }

    return dataset;
  }

  /// Z-Score Standardization: Rescales data to have a mean of 0 and std deviation of 1.
  static List<Map<String, dynamic>> zScoreStandardize(
      List<Map<String, dynamic>> dataset, String field) {
    // Extract the numerical values of the given field
    List<num> values = dataset.map((item) => item[field] as num).toList();

    // Calculate mean (μ) and standard deviation (σ)
    num mean = values.reduce((a, b) => a + b) / values.length;
    num variance = values
            .map((value) => (value - mean) * (value - mean))
            .reduce((a, b) => a + b) /
        values.length;
    num stdDev = sqrt((variance));

    // Standardize the data
    for (var item in dataset) {
      var value = item[field];
      item[field] = (value - mean) / stdDev;
    }

    return dataset;
  }
}
