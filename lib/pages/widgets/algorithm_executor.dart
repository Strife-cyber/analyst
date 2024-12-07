import 'package:analyst/algorithms/data_cleaner.dart';
import 'package:analyst/algorithms/data_aggregator.dart';
import 'package:analyst/algorithms/data_scaler.dart';

List<Map<String, dynamic>> executeAlgorithm(
    String algorithmName,
    String field,
    String groupByField,
    String numericalField,
    List<Map<String, dynamic>> dataset) {
  List<Map<String, dynamic>> processedData;

  switch (algorithmName) {
    case "Data Cleaning":
      processedData = _runDataCleaning(field, dataset);
      break;
    case "Data Aggregation":
      processedData =
          _runDataAggregation(groupByField, numericalField, dataset);
      break;
    case "Min-Max Normalization":
      processedData = _runMinMaxNormalization(field, dataset);
      break;
    case "Z-Score Standardization":
      processedData = _runZScoreStandardization(field, dataset);
      break;
    default:
      processedData = dataset;
  }

  return processedData;
}

List<Map<String, dynamic>> _runDataCleaning(
    String field, List<Map<String, dynamic>> dataset) {
  List<String> fields = field.split(',').map((f) => f.trim()).toList();
  return DataCleaner.removeMissingData(dataset, fields);
}

List<Map<String, dynamic>> _runDataAggregation(String groupByField,
    String numericalField, List<Map<String, dynamic>> dataset) {
  return [
    for (var entry in DataAggregator.aggregateByCategory(
            dataset, groupByField, numericalField)
        .entries)
      {
        "category": entry.key,
        "count": entry.value["count"],
        "sum": entry.value["sum"],
        "average": entry.value["average"],
        "min": entry.value["min"],
        "max": entry.value["max"],
      }
  ];
}

List<Map<String, dynamic>> _runMinMaxNormalization(
    String field, List<Map<String, dynamic>> dataset) {
  return DataScaler.minMaxNormalize(dataset, field);
}

List<Map<String, dynamic>> _runZScoreStandardization(
    String field, List<Map<String, dynamic>> dataset) {
  return DataScaler.zScoreStandardize(dataset, field);
}
