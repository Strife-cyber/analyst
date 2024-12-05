import 'package:flutter_test/flutter_test.dart';
import 'package:analyst/algorithms/data_cleaner.dart';

void main() {
  group('Data Cleaner Tests', () {
    test('Remove Missing Data', () {
      List<Map<String, dynamic>> dataset = [
        {"id": 1, "name": "John", "age": 18, "marks": 85},
        {"id": 2, "name": "Jane", "age": null, "marks": 90},
        {"id": 3, "name": "John", "age": 18, "marks": 85},
        {"id": 4, "name": "Doe", "age": 22, "marks": 45},
        {"id": 5, "name": "Alice", "age": 20, "marks": 88},
      ];

      // Perform Cleaning
      final cleaned =
          DataCleaner.removeMissingData(dataset, ["name", "age", "marks"]);

      // Expected dataset after removing rows with missing data
      final expected = [
        {"id": 1, "name": "John", "age": 18, "marks": 85},
        {"id": 3, "name": "John", "age": 18, "marks": 85},
        {"id": 4, "name": "Doe", "age": 22, "marks": 45},
        {"id": 5, "name": "Alice", "age": 20, "marks": 88},
      ];

      expect(cleaned, equals(expected));
    });

    test('Remove Duplicates', () {
      List<Map<String, dynamic>> dataset = [
        {"id": 1, "name": "John", "age": 18, "marks": 85},
        {"id": 2, "name": "Jane", "age": 20, "marks": 90},
        {"id": 3, "name": "John", "age": 18, "marks": 85}, // Duplicate
        {"id": 4, "name": "Doe", "age": 22, "marks": 45},
        {"id": 5, "name": "Alice", "age": 20, "marks": 88},
      ];

      // Perform cleaning
      final cleaned = DataCleaner.removeDuplicates(dataset, ["id", "name"]);

      // Expected dataset after removing duplicates
      final expected = [
        {"id": 1, "name": "John", "age": 18, "marks": 85},
        {"id": 2, "name": "Jane", "age": 20, "marks": 90},
        {"id": 4, "name": "Doe", "age": 22, "marks": 45},
        {"id": 5, "name": "Alice", "age": 20, "marks": 88},
      ];

      expect(cleaned, equals(expected));
    });

    test('Remove Outliers', () {
      List<Map<String, dynamic>> dataset = [
        {"id": 1, "name": "John", "age": 18, "marks": 85},
        {"id": 2, "name": "Jane", "age": 20, "marks": 90},
        {"id": 3, "name": "John", "age": 18, "marks": 85},
        {"id": 4, "name": "Doe", "age": 22, "marks": 45}, // Outlier (marks)
        {"id": 5, "name": "Alice", "age": 20, "marks": 88},
      ];

      // Perform cleaning
      final cleaned = DataCleaner.removeOutliers(dataset, "marks", 2.0);

      // Expected dataset after removing outliers
      final expected = [
        {"id": 1, "name": "John", "age": 18, "marks": 85},
        {"id": 2, "name": "Jane", "age": 20, "marks": 90},
        {"id": 3, "name": "John", "age": 18, "marks": 85},
        {"id": 5, "name": "Alice", "age": 20, "marks": 88},
      ];

      expect(cleaned, equals(expected));
    });
  });
}
