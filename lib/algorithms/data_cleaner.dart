import 'dart:math';

class DataCleaner {
  /// Remove entries with missing (null) values in specific fields
  static List<Map<String, dynamic>> removeMissingData(
      List<Map<String, dynamic>> dataset, List<String> requiredFields) {
    return dataset.where((entry) {
      return requiredFields.every((field) => entry[field] != null);
    }).toList();
  }

  /// Removes duplicate entries based on specific unique fields.
  static List<Map<String, dynamic>> removeDuplicates(
      List<Map<String, dynamic>> dataset, List<String> uniqueFields) {
    final seen = <String>[];

    return dataset.where((entry) {
      final key =
          uniqueFields.map((field) => entry[field]?.toString()).join('-');
      if (seen.contains(key)) {
        return false;
      } else {
        seen.add(key);
        return true;
      }
    }).toList();
  }

  /// Removes outliers from numerical fields based on Z-score threshold.
  static List<Map<String, dynamic>> removeOutliers(
      List<Map<String, dynamic>> dataset,
      String numericalField,
      double zThreshold) {
    final values = dataset
        .map((entry) => entry[numericalField] as num?)
        .whereType<num>()
        .toList();

    if (values.isEmpty) return dataset;

    // Calculate the mean and standard deviation
    final mean = values.reduce((a, b) => a + b) / values.length;
    final stdDev = sqrt((values.fold(
            0.0, (sum, value) => sum + (value - mean) * (value - mean)) /
        values.length));

    return dataset.where((entry) {
      final value = entry[numericalField];
      if (value is num) {
        final zScore = (value - mean).abs() / stdDev;
        return zScore <= zThreshold;
      }
      return true;
    }).toList();
  }
}
