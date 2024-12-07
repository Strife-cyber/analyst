import 'package:analyst/database/database_helper.dart';
import 'package:flutter/material.dart';

class DatasetSelector extends StatefulWidget {
  final Function(String) onDatasetSelected;

  const DatasetSelector({required this.onDatasetSelected, super.key});

  @override
  State<DatasetSelector> createState() => _DatasetSelectorState();
}

class _DatasetSelectorState extends State<DatasetSelector>
    with SingleTickerProviderStateMixin {
  List<String> datasets = []; // List to store available datasets
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Set up animation controller for fade-in effect
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _loadDatasets();
  }

  // Load datasets (tables and JSON files)
  Future<void> _loadDatasets() async {
    final databaseHelper = DatabaseHelper();
    final datasetFiles = await databaseHelper.getAllJsonFileNames();
    final datasetTables = await databaseHelper.getAllTableNames();

    setState(() {
      datasets = datasetFiles + datasetTables;
      _isLoading = false;
    });

    // Trigger the fade-in animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
            ),
          )
        : FadeTransition(
            opacity: _animation,
            child: ListView.builder(
              itemCount: datasets.length,
              itemBuilder: (context, index) {
                final datasetName = datasets[index];
                return _buildDatasetItem(datasetName);
              },
            ),
          );
  }

  // Build dataset item with style and hover effect
  Widget _buildDatasetItem(String datasetName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onDatasetSelected(datasetName),
          borderRadius: BorderRadius.circular(12.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: Colors.grey[300]!)),
            surfaceTintColor: Colors.green[200],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                datasetName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.green[400]!, // Green accent for the text
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
