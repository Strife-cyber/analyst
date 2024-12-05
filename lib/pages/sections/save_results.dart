import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SaveResultsButton extends StatelessWidget {
  final List<Map<String, dynamic>> results;

  const SaveResultsButton({required this.results, super.key});

  Future<void> _saveResults(BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/results.json');

    // Convert results to JSON
    String jsonString = jsonEncode(results);

    // Save to file
    await file.writeAsString(jsonString);

    // Show confirmation using a SnackBar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Results saved to ${file.path}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    // Debug log
    if (kDebugMode) {
      print('Results saved to ${file.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _saveResults(context),
      tooltip: 'Save Results',
      child: const Icon(Icons.save),
    );
  }
}
