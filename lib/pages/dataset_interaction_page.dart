import 'package:analyst/algorithms/data_aggregator.dart';
import 'package:analyst/algorithms/data_cleaner.dart';
import 'package:analyst/algorithms/data_scaler.dart';
import 'package:analyst/pages/sections/algorithm_selector.dart';
import 'package:analyst/pages/sections/algorithms_data.dart';
import 'package:analyst/pages/sections/dataset_selector.dart';
import 'package:analyst/pages/sections/dataset_table.dart';
import 'package:analyst/pages/sections/save_results.dart';
import 'package:analyst/pages/widgets/dataset_loader.dart';
import 'package:flutter/material.dart';

class DatasetInteractionPage extends StatefulWidget {
  const DatasetInteractionPage({super.key});

  @override
  State<DatasetInteractionPage> createState() => _DatasetInteractionPageState();
}

class _DatasetInteractionPageState extends State<DatasetInteractionPage> {
  String? selectedDataset;
  List<Map<String, dynamic>> dataset = [];
  List<Map<String, dynamic>> results = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Dataset Interaction', style: TextStyle(fontSize: 22)),
        backgroundColor: Colors.green[500],
      ),
      body: SafeArea(
        child: selectedDataset == null
            ? DatasetSelector(onDatasetSelected: (datasetName) async {
                List<Map<String, dynamic>> loadedDataset =
                    await loadDataset(datasetName);
                setState(() {
                  selectedDataset = datasetName;
                  dataset = loadedDataset;
                  results = dataset;
                });
              })
            : SingleChildScrollView(
                child: Column(
                  children: [
                    AlgorithmSelector(
                        algorithms: algorithmsUsed,
                        onAlgorithmSelected: (algorithmName) {
                          showParametersDialog(algorithmName);
                        }),
                    DatasetJsonTree(dataset: results),
                    SaveResultsButton(results: results),
                  ],
                ),
              ),
      ),
    );
  }

  /// Prompts the user for algorithm parameters and executes the selected algorithm
  void showParametersDialog(String algorithmName) {
    final TextEditingController fieldController = TextEditingController();
    final TextEditingController groupByFieldController =
        TextEditingController();
    final TextEditingController numericalFieldController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Parameters for $algorithmName"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (algorithmName == "Data Cleaning")
                TextField(
                  controller: fieldController,
                  decoration: const InputDecoration(
                    labelText: "Field(s) to clean (comma-separated)",
                  ),
                ),
              if (algorithmName == "Data Aggregation") ...[
                TextField(
                  controller: groupByFieldController,
                  decoration: const InputDecoration(
                    labelText: "Group by field",
                  ),
                ),
                TextField(
                  controller: numericalFieldController,
                  decoration: const InputDecoration(
                    labelText: "Numerical field to aggregate",
                  ),
                ),
              ],
              if (algorithmName == "Min-Max Normalization" ||
                  algorithmName == "Z-Score Standardization")
                TextField(
                  controller: fieldController,
                  decoration: const InputDecoration(
                    labelText: "Field to normalize",
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                executeAlgorithm(
                  algorithmName,
                  fieldController.text,
                  groupByFieldController.text,
                  numericalFieldController.text,
                );
              },
              child: const Text("Run"),
            ),
          ],
        );
      },
    );
  }

  /// Executes the algorithm based on the user's input
  void executeAlgorithm(
    String algorithmName,
    String field,
    String groupByField,
    String numericalField,
  ) {
    List<Map<String, dynamic>> processedData;

    switch (algorithmName) {
      case "Data Cleaning":
        List<String> fields = field.split(',').map((f) => f.trim()).toList();
        processedData = DataCleaner.removeMissingData(dataset, fields);
        break;

      case "Data Aggregation":
        processedData = [
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
        break;

      case "Min-Max Normalization":
        processedData = DataScaler.minMaxNormalize(dataset, field);
        break;

      case "Z-Score Standardization":
        processedData = DataScaler.zScoreStandardize(dataset, field);
        break;

      default:
        processedData = dataset;
    }

    setState(() {
      results = processedData;
    });
  }
}
