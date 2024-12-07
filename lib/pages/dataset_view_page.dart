import 'package:analyst/database/database_helper.dart';
import 'package:analyst/pages/dataset_page.dart';
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
  List<String> _filteredDbDatasets = [];
  List<String> _filteredFileDatasets = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDatasets();
    _searchController.addListener(_filterDatasets);
  }

  Future<void> _loadDatasets() async {
    // Load datasets from database and files
    final dbTableNames = await _dbHelper.getAllTableNames();
    final fileNames = await _dbHelper.getAllJsonFileNames();

    setState(() {
      _datasetsFromDb = dbTableNames;
      _datasetsFromFiles = fileNames;
      _filteredDbDatasets = dbTableNames;
      _filteredFileDatasets = fileNames;
    });
  }

  // Function to filter datasets based on search query
  void _filterDatasets() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredDbDatasets = _datasetsFromDb
          .where((dataset) => dataset.toLowerCase().contains(query))
          .toList();
      _filteredFileDatasets = _datasetsFromFiles
          .where((dataset) => dataset.toLowerCase().contains(query))
          .toList();
    });
  }

  // Function to handle opening a dataset (can navigate to a different page or display data)
  void _openDataset(String datasetName) {
    // Implement logic to open dataset
    if (kDebugMode) {
      print("Opening dataset: $datasetName");
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DatasetPage(datasetName: datasetName)));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search datasets...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),

            // Datasets from Database
            Expanded(
              child: ListView.builder(
                itemCount: _filteredDbDatasets.length,
                itemBuilder: (context, index) {
                  final datasetName = _filteredDbDatasets[index];
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: DatasetCard(
                      key: ValueKey(datasetName),
                      datasetName: datasetName,
                      onOpen: () => _openDataset(datasetName),
                      isTable: true,
                      onDelete: () {
                        setState(() {});
                      },
                    ),
                  );
                },
              ),
            ),

            // Datasets from Files (JSON)
            Expanded(
              child: ListView.builder(
                itemCount: _filteredFileDatasets.length,
                itemBuilder: (context, index) {
                  final datasetName = _filteredFileDatasets[index];
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: DatasetCard(
                      key: ValueKey(datasetName),
                      datasetName: datasetName,
                      onOpen: () => _openDataset(datasetName),
                      isTable: false,
                      onDelete: () {
                        setState(() {});
                      },
                    ),
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
