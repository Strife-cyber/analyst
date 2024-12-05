import 'package:flutter/material.dart';

class AlgorithmSelector extends StatelessWidget {
  final List<Map<String, String>> algorithms;
  final Function(String) onAlgorithmSelected;

  const AlgorithmSelector({
    required this.algorithms,
    required this.onAlgorithmSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String? selectedAlgorithm;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Algorithm:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 220,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.green[200]!),
                    borderRadius: BorderRadius.circular(8.0)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DropdownButton<String>(
                    value: selectedAlgorithm,
                    hint: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Choose an algorithm'),
                    ),
                    items: algorithms.map((algorithm) {
                      return DropdownMenuItem<String>(
                        value: algorithm['name'],
                        child: Text(algorithm['name']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAlgorithm = value;
                      });
                      if (value != null) {
                        _showAlgorithmDetails(context, value, algorithms);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Show algorithm details in a dialog
  void _showAlgorithmDetails(
    BuildContext context,
    String selectedAlgorithm,
    List<Map<String, String>> algorithms,
  ) {
    final algorithmDetails = algorithms.firstWhere(
      (algo) => algo['name'] == selectedAlgorithm,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(algorithmDetails['name']!),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Purpose:', algorithmDetails['purpose']),
                _buildDetailRow('Function:', algorithmDetails['function']),
                _buildDetailRow('Steps:', algorithmDetails['steps']),
                _buildDetailRow('Example:', algorithmDetails['example']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onAlgorithmSelected(algorithmDetails['name']!);
              },
              child: const Text('Validate'),
            ),
          ],
        );
      },
    );
  }

  /// Helper to build each detail row
  Widget _buildDetailRow(String title, String? content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4.0),
          Text(content ?? 'N/A'),
        ],
      ),
    );
  }
}
