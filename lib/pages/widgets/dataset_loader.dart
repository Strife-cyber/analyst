import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:analyst/database/database_helper.dart';

Future<List<Map<String, dynamic>>> loadDataset(String datasetName) async {
  try {
    if (datasetName.endsWith('.json')) {
      String jsonString =
          await rootBundle.loadString('assets/datasets/$datasetName');
      return List<Map<String, dynamic>>.from(json.decode(jsonString));
    } else {
      DatabaseHelper dbHelper = DatabaseHelper();
      return await dbHelper.fetchData(datasetName);
    }
  } catch (e) {
    if (kDebugMode) print('Error loading dataset: $e');
    return [];
  }
}
