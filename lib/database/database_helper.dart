import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Open or create the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'dynamic_db.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // This method will be called when the database is created
  Future<void> _onCreate(Database db, int version) async {
    // You can predefine some initial tables if needed
  }

  // Create a table dynamically
  Future<void> createTable(
      String tableName, List<Map<String, dynamic>> parsedData) async {
    final db = await database;

    // Initialize the SQL for creating the table with the 'id' column as the primary key
    String createTableSQL =
        'CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, ';

    // Dynamically define columns based on the first row's keys
    final firstRow = parsedData.first;
    List<String> columns = firstRow.keys.map((key) {
      // Skip the 'id' column if it exists in the data
      if (key == 'id') return ''; // We'll remove it later from the column list
      String columnType = inferColumnType(firstRow[key]);
      return '$key $columnType';
    }).toList();

    // Remove empty entries for 'id' and join the rest of the columns
    columns.removeWhere((column) => column.isEmpty);
    createTableSQL += '${columns.join(', ')})';

    await db.execute(createTableSQL);
  }

  // Insert data into the dynamic table
  Future<void> insertData(
      String tableName, List<Map<String, dynamic>> data) async {
    final db = await database;
    for (var row in data) {
      await db.insert(tableName, row);
    }
  }

  // Fetch data from the dynamic table
  Future<List<Map<String, dynamic>>> fetchData(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  // Helper method to infer column types based on data
  String inferColumnType(dynamic value) {
    if (value is int) {
      return 'INTEGER';
    } else if (value is double) {
      return 'REAL';
    } else if (value is String) {
      return 'TEXT';
    } else if (value is bool) {
      return 'BOOLEAN';
    } else {
      return 'TEXT'; // Default to TEXT if type is unknown
    }
  }

  // Treat data before insertion, handling null values and duplicate columns
  List<Map<String, dynamic>> treatData(List<Map<String, dynamic>> parsedData) {
    List<Map<String, dynamic>> errorData = [];

    List<int> rowsToRemove = []; // To track rows that need to be removed

    for (int i = 0; i < parsedData.length; i++) {
      Map<String, dynamic> row = parsedData[i];
      Map<String, dynamic> errors = {};

      row.removeWhere((key, value) {
        if (key == 'id') {
          // Remove duplicate 'id' key directly to avoid conflict
          return true;
        } else if (value == null) {
          // If null, move to errors and mark for removal
          errors[key] = value;
          return true;
        }
        return false; // Keep other key-value pairs
      });

      // If there are errors in this row, add to errorData
      if (errors.isNotEmpty) {
        errorData.add(errors);
        rowsToRemove.add(i); // Mark row for removal
      }
    }

    // Remove rows with errors from parsedData
    for (int i = rowsToRemove.length - 1; i >= 0; i--) {
      parsedData.removeAt(rowsToRemove[i]);
    }

    return errorData;
  }

  // Fetch all JSON file names from the "datasets" folder
  Future<List<String>> getAllJsonFileNames() async {
    final directory = await getApplicationDocumentsDirectory();
    final datasetsDirectory = Directory('${directory.path}/datasets');

    // Check if the 'datasets' directory exists, if not, create it
    if (!await datasetsDirectory.exists()) {
      await datasetsDirectory.create(recursive: true);
    }

    // Now list the files
    final datasetFiles = datasetsDirectory
        .listSync()
        .where((file) => file is File && file.path.endsWith('.json'))
        .toList();

    return datasetFiles.map((file) => file.uri.pathSegments.last).toList();
  }

  // Get all table names in the database
  Future<List<String>> getAllTableNames() async {
    final db = await database;
    final result = await db
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    return result.map((table) => table['name'] as String).toList();
  }
}
