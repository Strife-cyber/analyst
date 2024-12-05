import 'package:analyst/database/database_helper.dart';
import 'package:flutter/material.dart';

class DatasetSelector extends StatefulWidget {
  final Function(String) onDatasetSelected;

  const DatasetSelector({required this.onDatasetSelected, super.key});

  @override
  State<DatasetSelector> createState() => _DatasetSelectorState();
}

class _DatasetSelectorState extends State<DatasetSelector> {
  List<String> datasets = []; // List to store available datasets

  @override
  void initState() {
    super.initState();
    _loadDatasets();
  }

  // Load datasets (tables and JSON files)
  Future<void> _loadDatasets() async {
    final databaseHelper = DatabaseHelper();
    final datasetFiles = await databaseHelper.getAllJsonFileNames();
    final datasetTables = await databaseHelper.getAllTableNames();

    setState(() {
      datasets = datasetFiles + datasetTables;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: datasets.length,
      itemBuilder: (context, index) {
        final datasetName = datasets[index];
        return ListTile(
          title: Text(datasetName),
          onTap: () => widget.onDatasetSelected(datasetName),
        );
      },
    );
  }
}
