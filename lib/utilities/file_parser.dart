import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:xml/xml.dart';
import 'package:flutter/foundation.dart';

class FileParser {
  final String filename;
  final List<int> filebytes;

  const FileParser({required this.filename, required this.filebytes});

  Future<List<Map<String, dynamic>>> _readCsv(String input) async {
    try {
      final rows = const CsvToListConverter().convert(input, eol: '\n');

      if (rows.isEmpty) return [];

      final headerRow = rows[0];
      final headers = headerRow.map((item) => item.toString()).toList();

      final data = rows.sublist(1);

      return data.map((row) {
        return Map.fromIterables(headers, row.map((item) => item.toString()));
      }).toList();
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error while parsing CSV: $e\n$stacktrace');
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _readJson(String input) async {
    try {
      final data = jsonDecode(input) as List;

      if (data.isNotEmpty) {
        final List<String> headers = data[0].keys.toList();

        return data.map((e) {
          // Handle missing or null values
          return Map.fromIterables(headers, e.values.map((value) => value));
        }).toList();
      }
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error while parsing JSON: $e\n$stacktrace');
      }
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> _readXml(String input) async {
    try {
      final document = XmlDocument.parse(input);
      final rows = document.findAllElements('row');
      List<Map<String, dynamic>> result = [];

      if (rows.isNotEmpty) {
        final firstRow = rows.first.children.whereType<XmlElement>().toList();
        final headers = firstRow.map((e) => e.name.local).toList();

        for (var row in rows) {
          Map<String, dynamic> rowMap = {};
          final fields = row.children.whereType<XmlElement>().toList();
          for (int i = 0; i < fields.length; i++) {
            rowMap[headers[i]] = fields[i].value!.trim();
          }
          result.add(rowMap);
        }
      }

      return result;
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error while parsing XML: $e\n$stacktrace');
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> parseFile() async {
    final fileContent = String.fromCharCodes(filebytes);

    try {
      if (filename.endsWith('.csv')) {
        return await _readCsv(fileContent);
      } else if (filename.endsWith('.json')) {
        return await _readJson(fileContent);
      } else if (filename.endsWith('.xml')) {
        return await _readXml(fileContent);
      } else {
        if (kDebugMode) {
          print('Unsupported file format: $filename');
        }
        return [];
      }
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error while parsing file: $e\n$stacktrace');
      }
      return [];
    }
  }
}
