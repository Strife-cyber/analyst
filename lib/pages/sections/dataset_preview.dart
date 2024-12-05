import 'package:flutter/material.dart';

class DatasetPreviewSection extends StatelessWidget {
  final List<Map<String, dynamic>> filePreviewData;

  const DatasetPreviewSection({required this.filePreviewData, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Dataset Preview:",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap:
                    true, // Use this to make the list scrollable inside its container
                itemCount: filePreviewData.length,
                itemBuilder: (context, index) {
                  final row = filePreviewData[index];

                  // Extract values from the map
                  final values = row.values.toList();

                  return Container(
                    color: index % 2 == 0 ? Colors.green[100] : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        children: values
                            .map((cell) => SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: 200,
                                    height: 40,
                                    child: SelectableText(
                                      cell.toString(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
