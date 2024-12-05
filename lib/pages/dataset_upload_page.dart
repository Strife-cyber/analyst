import 'package:analyst/database/database_helper.dart';
import 'package:file_selector/file_selector.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:analyst/pages/sections/action_buttons.dart';
import 'package:analyst/pages/sections/dataset_preview.dart';
import 'package:analyst/pages/sections/file_upload.dart';
import 'package:analyst/utilities/file_parser.dart';

class DatasetUploadPage extends StatefulWidget {
  const DatasetUploadPage({super.key});

  @override
  State<DatasetUploadPage> createState() => _DatasetUploadPageState();
}

class _DatasetUploadPageState extends State<DatasetUploadPage>
    with SingleTickerProviderStateMixin {
  String? _uploadedFileName;
  List<Map<String, dynamic>>? _filePreviewData;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  List<Map<String, dynamic>> fileData = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _uploadFile() async {
    // Use file_selector to pick files
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'documents',
      extensions: ['csv', 'json', 'xml'],
    );

    // Open file picker dialog
    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file != null) {
      // Read the file as bytes
      final fileBytes = await file.readAsBytes();
      final fileName = file.name;

      final fileParser = FileParser(filename: fileName, filebytes: fileBytes);
      fileData = await fileParser.parseFile(); // Ensure fileData is never null

      setState(() {
        _uploadedFileName = fileName;
        _filePreviewData =
            fileData.length > 5 ? fileData.sublist(0, 5) : fileData;
      });
    } else {
      // Handle case where no file was selected
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No file selected")),
        );
      }
    }
  }

  Future<void> _saveToDatabase() async {
    if (_filePreviewData != null && _filePreviewData!.isNotEmpty) {
      String tableName = await _showTableNameDialog(context);

      if (tableName.isNotEmpty) {
        // Here, you would save the dataset to the database using the tableName
        if (mounted) {
          final databaseHelper = DatabaseHelper();
          databaseHelper.createTable(tableName, fileData);
          databaseHelper.insertData(tableName, fileData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Dataset saved to table: $tableName")),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No dataset to save.")),
      );
    }
  }

  Future<String> _showTableNameDialog(BuildContext context) async {
    TextEditingController tableNameController = TextEditingController();
    String tableName = "";

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Table Name"),
          content: TextField(
            controller: tableNameController,
            decoration: const InputDecoration(hintText: "Table name"),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                tableName = tableNameController.text;
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );

    return tableName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dataset Upload", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.green[500],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FileUploadSection(
                scaleAnimation: _scaleAnimation,
                uploadedFileName: _uploadedFileName,
                onUploadFile: _uploadFile,
              ),
              const SizedBox(height: 16),
              if (_filePreviewData != null && _filePreviewData!.isNotEmpty)
                DatasetPreviewSection(filePreviewData: _filePreviewData!),
              const SizedBox(height: 16),
              ActionButtons(
                onPreviewDataset: _uploadFile,
                onSaveToDatabase: _saveToDatabase,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
