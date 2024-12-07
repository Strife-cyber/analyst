import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SaveResultsButton extends StatefulWidget {
  final List<Map<String, dynamic>> results;

  const SaveResultsButton({required this.results, super.key});

  @override
  State<SaveResultsButton> createState() => _SaveResultsButtonState();
}

class _SaveResultsButtonState extends State<SaveResultsButton> {
  bool _isHovered = false;

  Future<void> _saveResults(BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/results.json');

    // Convert results to JSON
    String jsonString = jsonEncode(widget.results);

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
    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          Positioned(
            bottom: 5,
            right: 16,
            child: AnimatedScale(
              scale: _isHovered ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: FloatingActionButton(
                onPressed: () {
                  _saveResults(context);
                  _isHovered = !_isHovered;
                },
                tooltip: 'Save Results',
                backgroundColor: Colors.green[300], // Light green color
                child: const Icon(Icons.save, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
