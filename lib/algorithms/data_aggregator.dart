class DataAggregator {
  /// Groups the dataset by a categorical field and applies aggregation functions.
  /// [groupByField]: The categorical field to group by (e.g., "type", "cuisine").
  /// [numericalField]: The numerical field to aggregate (e.g., "price", "calories").
  /// [filters]: A list of optional filter functions to include or exclude rows based on conditions.
  static Map<String, Map<String, dynamic>> aggregateByCategory(
      List<Map<String, dynamic>> dataset,
      String groupByField,
      String numericalField,
      {List<bool Function(Map<String, dynamic>)>? filters}) {
    // Apply filters if provided
    if (filters != null && filters.isNotEmpty) {
      dataset = dataset.where((item) {
        for (var filter in filters) {
          if (!filter(item)) return false; // Exclude if any filter fails
        }
        return true;
      }).toList();
    }

    // Grouped results
    Map<String, List<Map<String, dynamic>>> groupedData = {};

    // Group dataset by the categorical field
    for (var item in dataset) {
      String groupKey = item[groupByField]?.toString() ??
          "Unknown"; // Using a single categorical field
      if (!groupedData.containsKey(groupKey)) {
        groupedData[groupKey] = [];
      }
      groupedData[groupKey]?.add(item);
    }

    // Perform aggregation for each group
    Map<String, Map<String, dynamic>> aggregatedResults = {};
    groupedData.forEach((category, items) {
      List<num> numericalValues = items
          .map((item) => item[numericalField] as num?)
          .where((value) => value != null)
          .cast<num>()
          .toList();

      if (numericalValues.isNotEmpty) {
        aggregatedResults[category] = {
          "count": numericalValues.length,
          "sum": numericalValues.reduce((a, b) => a + b),
          "average":
              numericalValues.reduce((a, b) => a + b) / numericalValues.length,
          "min": numericalValues.reduce((a, b) => a < b ? a : b),
          "max": numericalValues.reduce((a, b) => a > b ? a : b)
        };
      } else {
        aggregatedResults[category] = {
          "count": 0,
          "sum": 0,
          "average": 0,
          "min": null,
          "max": null
        };
      }
    });

    return aggregatedResults;
  }

  // Standard filters

  /// Filter for numerical values within a given range.
  static bool Function(Map<String, dynamic> item) filterByRange(
      String field, num min, num max) {
    return (Map<String, dynamic> item) {
      var value = item[field];
      return value != null && value >= min && value <= max;
    };
  }

  /// Filter by exact match for a categorical field.
  static bool Function(Map<String, dynamic> item) filterByExactMatch(
      String field, String value) {
    return (Map<String, dynamic> item) {
      var fieldValue = item[field]?.toString();
      return fieldValue != null && fieldValue == value;
    };
  }

  /// Filter by inclusion in a set of values for a categorical field.
  static bool Function(Map<String, dynamic> item) filterByInclusion(
      String field, List<String> values) {
    return (Map<String, dynamic> item) {
      var fieldValue = item[field]?.toString();
      return fieldValue != null && values.contains(fieldValue);
    };
  }
}
