import 'package:analyst/database/database_helper.dart';
import 'package:analyst/pages/sections/dataset_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DatasetViewPage extends StatefulWidget {
  const DatasetViewPage({super.key});

  @override
  State<DatasetViewPage> createState() => _DatasetViewPageState();
}

class _DatasetViewPageState extends State<DatasetViewPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<String> _datasetsFromDb = [];
  List<String> _datasetsFromFiles = [];

  @override
  void initState() {
    super.initState();
    _loadDatasets();
  }

  Future<void> _loadDatasets() async {
    // Load datasets from database and files
    final dbTableNames = await _dbHelper.getAllTableNames();
    final fileNames = await _dbHelper.getAllJsonFileNames();

    setState(() {
      _datasetsFromDb = dbTableNames;
      _datasetsFromFiles = fileNames;
    });
  }

  // Optionally, add a function to open a dataset, delete or export
  void _openDataset(String datasetName) {
    // Implement logic to open the dataset, could be a new page to view the data
    if (kDebugMode) {
      print("Opening dataset: $datasetName");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Existing Datasets"),
        backgroundColor: Colors.green[500],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar and Filters can go here

            // Datasets from Database
            Expanded(
              child: ListView.builder(
                itemCount: _datasetsFromDb.length,
                itemBuilder: (context, index) {
                  final datasetName = _datasetsFromDb[index];
                  return DatasetCard(
                    datasetName: datasetName,
                    onOpen: () => _openDataset(datasetName),
                    isTable: true,
                  );
                },
              ),
            ),

            // Datasets from Files (JSON)
            Expanded(
              child: ListView.builder(
                itemCount: _datasetsFromFiles.length,
                itemBuilder: (context, index) {
                  final datasetName = _datasetsFromFiles[index];
                  return DatasetCard(
                    datasetName: datasetName,
                    onOpen: () => _openDataset(datasetName),
                    isTable: false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
