import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:analyst/utilities/file_parser.dart'; // Include the FileParser class from your previous code
import 'package:analyst/database/database_helper.dart'; // Include the DatabaseHelper class from your previous code

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Database File Uploader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FileUploadScreen(),
    );
  }
}

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  File? _selectedFile;
  String _queryResult = '';
  final TextEditingController _queryController = TextEditingController();

  // Instance of DatabaseHelper to create and query tables
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Function to select file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'json', 'xml'],
    );

    if (result != null) {
      final file = result.files.single;

      setState(() {
        _selectedFile = File(file.path!);
        _processFile();
      });
    }
  }

  // Function to process the selected file and insert it into the database
  Future<void> _processFile() async {
    if (_selectedFile == null) return;

    final fileBytes = await _selectedFile!.readAsBytes();
    final fileName = basename(_selectedFile!.path);

    // Create the file parser
    final fileParser = FileParser(filename: fileName, filebytes: fileBytes);
    if (kDebugMode) {
      print(fileName);
    }

    // Parse the file and get the data as Map
    List<Map<String, dynamic>> parsedData = await fileParser.parseFile();
    final errors = _dbHelper.treatData(parsedData);

    if (kDebugMode) {
      print(errors);
    }

    // Dynamically create a table based on the parsed data
    if (parsedData.isNotEmpty) {
      await _dbHelper.createTable(fileName, parsedData);
      await _dbHelper.insertData(fileName, parsedData);
      setState(() {
        _queryResult = 'Table created and data inserted successfully!';
      });
    } else {
      setState(() {
        _queryResult = 'No valid data found in the file!';
      });
    }
  }

  // Function to execute custom SQL queries
  Future<void> _executeQuery() async {
    if (_queryController.text.isNotEmpty) {
      final result = await _dbHelper.database.then((db) async {
        return await db.rawQuery(_queryController.text);
      });

      setState(() {
        _queryResult =
            result.isNotEmpty ? result.toString() : 'No results found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database File Uploader'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Pick File (CSV, JSON, XML)'),
            ),
            const SizedBox(height: 20),
            if (_selectedFile != null)
              Text('Selected file: ${basename(_selectedFile!.path)}'),
            const SizedBox(height: 20),
            TextField(
              controller: _queryController,
              decoration: const InputDecoration(
                labelText: 'Enter SQL Query',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _executeQuery,
              child: const Text('Execute SQL Query'),
            ),
            const SizedBox(height: 20),
            const Text('Query Result:'),
            const SizedBox(height: 10),
            Text(_queryResult),
          ],
        ),
      ),
    );
  }
}
