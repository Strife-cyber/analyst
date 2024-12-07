import 'package:flutter/material.dart';
import 'package:analyst/pages/widgets/dataset_loader.dart';
import 'package:analyst/pages/sections/dataset_table.dart';

class DatasetPage extends StatefulWidget {
  final String datasetName;

  const DatasetPage({super.key, required this.datasetName});

  @override
  State<DatasetPage> createState() => _DatasetPageState();
}

class _DatasetPageState extends State<DatasetPage> {
  late Future<List<Map<String, dynamic>>> data;

  // Fetch the dataset asynchronously
  Future<List<Map<String, dynamic>>> _fetchData() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading delay
    return await loadDataset(widget
        .datasetName); // Replace with your actual dataset loading function
  }

  @override
  void initState() {
    super.initState();
    data = _fetchData(); // Start loading data when the page initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          widget.datasetName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while data is being fetched
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            );
          } else if (snapshot.hasError) {
            // Show an error message if fetching fails
            return const Center(
              child: Text(
                'Error loading dataset',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle case where no data is returned
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            // Display the dataset once data is loaded
            return AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: DatasetJsonTree(dataset: snapshot.data!),
            );
          }
        },
      ),
    );
  }
}
