import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart'; // For SQLite operations

class DatasetCard extends StatefulWidget {
  final String datasetName;
  final VoidCallback onOpen;
  final bool isTable; // To distinguish between table and JSON file

  const DatasetCard({
    required this.datasetName,
    required this.onOpen,
    required this.isTable, // Added parameter to identify dataset type
    super.key,
  });

  @override
  State<DatasetCard> createState() => _DatasetCardState();
}

class _DatasetCardState extends State<DatasetCard> {
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
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      child: ListTile(
        title: Text(widget.datasetName),
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
                // Handle deletion based on dataset type
                if (kDebugMode) {
                  print("Deleting dataset: ${widget.datasetName}");
                }

                if (widget.isTable) {
                  // Delete the table if it is a database table
                  await deleteTable(widget.datasetName);
                  setState(() {});
                } else {
                  // Delete the JSON file if it is a JSON dataset
                  await deleteJsonFile(widget.datasetName);
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
