import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onPreviewDataset;
  final VoidCallback onSaveToDatabase;

  const ActionButtons({
    required this.onPreviewDataset,
    required this.onSaveToDatabase,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onPreviewDataset,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF43A047),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "Preview Dataset",
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: onSaveToDatabase,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B5E20),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "Save to Database",
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
