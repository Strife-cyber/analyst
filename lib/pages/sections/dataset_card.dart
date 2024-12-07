import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart'; // For SQLite operations

class DatasetCard extends StatefulWidget {
  final String datasetName;
  final VoidCallback onOpen;
  final bool isTable; // To distinguish between table and JSON file
  final VoidCallback onDelete; // Callback for parent to remove item from list

  const DatasetCard({
    required this.datasetName,
    required this.onOpen,
    required this.isTable, // Added parameter to identify dataset type
    required this.onDelete, // Callback to notify the parent to remove item
    super.key,
  });

  @override
  State<DatasetCard> createState() => _DatasetCardState();
}

class _DatasetCardState extends State<DatasetCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Set up the animation controller for fade-out effect
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  // Helper method to delete a table from the database
  Future<void> deleteTable(String tableName) async {
    final db = await _getDatabase();
    await db.execute('DROP TABLE IF EXISTS $tableName');
  }

  // Helper method to get the database instance
  Future<Database> _getDatabase() async {
    final directory = await getDatabasesPath();
    final path = '$directory/dynamic_db.db'; // Path to the database
    return await openDatabase(path);
  }

  // Helper method to delete a JSON file
  Future<void> deleteJsonFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final datasetDirectory = Directory('${directory.path}/datasets');
    final file = File('${datasetDirectory.path}/$fileName');

    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Colors.green.shade50, // Green accent background color
        child: ListTile(
          title: Text(
            widget.datasetName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700, // Green accent text color
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: widget.onOpen,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  // Show a snackbar to inform the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Deleting dataset: ${widget.datasetName}"),
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  if (kDebugMode) {
                    print("Deleting dataset: ${widget.datasetName}");
                  }

                  // Fade out the card before deleting
                  await _controller.forward();

                  // Handle deletion based on dataset type
                  if (widget.isTable) {
                    // Delete the table if it is a database table
                    await deleteTable(widget.datasetName);
                  } else {
                    // Delete the JSON file if it is a JSON dataset
                    await deleteJsonFile(widget.datasetName);
                  }

                  // Notify the parent widget to update the UI
                  widget.onDelete();

                  // After deleting, navigate back or update UI as needed
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
