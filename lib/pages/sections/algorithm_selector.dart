import 'package:flutter/material.dart';

class AlgorithmSelector extends StatefulWidget {
  final List<Map<String, String>> algorithms;
  final Function(String) onAlgorithmSelected;

  const AlgorithmSelector({
    required this.algorithms,
    required this.onAlgorithmSelected,
    super.key,
  });

  @override
  State<AlgorithmSelector> createState() => _AlgorithmSelectorState();
}

class _AlgorithmSelectorState extends State<AlgorithmSelector> {
  String? selectedAlgorithm;
  bool isLoading = false; // To track loading state

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Algorithm:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[400],
                ),
              ),
              Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[100]!, Colors.green[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DropdownButton<String>(
                    value: selectedAlgorithm,
                    hint: const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text('Choose an algorithm'),
                    ),
                    dropdownColor: Colors.green[100],
                    style: const TextStyle(
                        color: Colors.black26, fontWeight: FontWeight.bold),
                    items: widget.algorithms.map((algorithm) {
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
                        _showAlgorithmDetails(
                            context, value, widget.algorithms);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          if (isLoading) // Show the circular progress indicator when loading
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
              ),
            ),
        ],
      ),
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
          backgroundColor: Colors.deepPurple[50],
          title: Text(
            algorithmDetails['name']!,
            style: TextStyle(
                color: Colors.deepPurple[800], fontWeight: FontWeight.bold),
          ),
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
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _onAlgorithmValidated();
                widget.onAlgorithmSelected(algorithmDetails['name']!);
              },
              child:
                  const Text('Validate', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  // Method to handle algorithm validation and show loading indicator
  void _onAlgorithmValidated() {
    setState(() {
      isLoading = true;
    });

    // Simulate a 10s process (for example, algorithm calculation)
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false; // Stop loading after 10 seconds
      });
    });
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[700],
            ),
          ),
          const SizedBox(height: 4.0),
          Text(content ?? 'N/A', style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}
