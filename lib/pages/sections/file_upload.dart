import 'package:flutter/material.dart';

class FileUploadSection extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final String? uploadedFileName;
  final VoidCallback onUploadFile;

  const FileUploadSection({
    required this.scaleAnimation,
    required this.uploadedFileName,
    required this.onUploadFile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green[300]!, width: 2),
          borderRadius: BorderRadius.circular(5),
          color: Colors.green[100],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.upload_file,
                size: 40,
                color: Colors.green[300],
              ),
              const SizedBox(height: 8),
              Text(
                "Drop your file here or tap to browse",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500]),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onUploadFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300], // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Border radius
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: const Text(
                  "Browse File",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              if (uploadedFileName != null) ...[
                const SizedBox(height: 5),
                Text(
                  "Uploaded: $uploadedFileName",
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
