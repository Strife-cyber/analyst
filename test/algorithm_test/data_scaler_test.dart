import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:analyst/algorithms/data_scaler.dart';

void main() {
  group('Data Scaler Test', () {
    // Sample dataset for testing
    List<Map<String, dynamic>> mealDataset = [
      {"id": 1, "name": "Pasta", "price": 10},
      {"id": 2, "name": "Burger", "price": 15},
      {"id": 3, "name": "Pizza", "price": 20},
      {"id": 4, "name": "Salad", "price": 8},
      {"id": 5, "name": "Steak", "price": 25},
    ];

    // Test for Min-Max Normalization
    test('Min-Max Normalization should scale prices to range [0, 1]', () {
      var normalizedData = DataScaler.minMaxNormalize(mealDataset, 'price');

      // Check that prices are normalized between 0 and 1
      expect(normalizedData[0]['price'],
          closeTo(0.10, 0.02)); // Pasta (price = 10)
      expect(normalizedData[1]['price'],
          closeTo(0.40, 0.02)); // Burger (price = 15)
      expect(normalizedData[2]['price'],
          closeTo(0.70, 0.02)); // Pizza (price = 20)
      expect(normalizedData[3]['price'],
          closeTo(0.000, 0.02)); // Salad (price = 8)
      expect(normalizedData[4]['price'],
          closeTo(1.00, 0.02)); // Steak (price = 25)
    });

    // Test for Z-Score Standardization
    test(
        'Z-Score Standardization should standardize prices to mean=0 and stdDev=1',
        () {
      var standardizedData = DataScaler.zScoreStandardize(mealDataset, 'price');

      // Calculate the expected mean and standard deviation for the prices
      List<num> prices =
          mealDataset.map((item) => item['price'] as num).toList();
      num mean = prices.reduce((a, b) => a + b) / prices.length;
      num variance = prices
              .map((value) => (value - mean) * (value - mean))
              .reduce((a, b) => a + b) /
          prices.length;
      num stdDev = sqrt(variance);

      // Test that the z-scores are close to the expected values
      expect(standardizedData[0]['price'],
          closeTo((prices[0] - mean) / stdDev, 0.01)); // Pasta
      expect(standardizedData[1]['price'],
          closeTo((prices[1] - mean) / stdDev, 0.01)); // Burger
      expect(standardizedData[2]['price'],
          closeTo((prices[2] - mean) / stdDev, 0.01)); // Pizza
      expect(standardizedData[3]['price'],
          closeTo((prices[3] - mean) / stdDev, 0.01)); // Salad
      expect(standardizedData[4]['price'],
          closeTo((prices[4] - mean) / stdDev, 0.01)); // Steak
    });
  });
}
