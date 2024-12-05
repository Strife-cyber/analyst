import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:analyst/algorithms/data_aggregator.dart';

void main() {
  group('Data Aggregator Tests', () {
    List<Map<String, dynamic>> mealDataset = [
      {
        "id": 1,
        "name": "Pasta",
        "type": "Vegetarian",
        "cuisine": "Italian",
        "calories": 400,
        "price": 10
      },
      {
        "id": 2,
        "name": "Burger",
        "type": "Non-Vegetarian",
        "cuisine": "American",
        "calories": 700,
        "price": 15
      },
      {
        "id": 3,
        "name": "Salad",
        "type": "Vegetarian",
        "cuisine": "Mediterranean",
        "calories": 200,
        "price": 8
      },
      {
        "id": 4,
        "name": "Steak",
        "type": "Non-Vegetarian",
        "cuisine": "American",
        "calories": 800,
        "price": 25
      },
      {
        "id": 5,
        "name": "Pizza",
        "type": "Vegetarian",
        "cuisine": "Italian",
        "calories": 600,
        "price": 12
      },
    ];

    test('Aggregation without filters', () {
      var aggregation =
          DataAggregator.aggregateByCategory(mealDataset, "type", "calories");

      // Expected aggregation result without filters
      var expectedAggregation = {
        "Vegetarian": {
          "count": 3,
          "sum": 1200,
          "average": 400.0,
          "min": 200,
          "max": 600
        },
        "Non-Vegetarian": {
          "count": 2,
          "sum": 1500,
          "average": 750.0,
          "min": 700,
          "max": 800
        }
      };

      expect(aggregation, equals(expectedAggregation));

      if (kDebugMode) {
        print(aggregation);
      }
    });

    test('Aggregation with filters (calories > 500)', () {
      // Filter to only include meals with calories > 500
      bool filterCaloriesGreaterThan500(Map<String, dynamic> item) =>
          item['calories'] > 500;

      var aggregation = DataAggregator.aggregateByCategory(
        mealDataset,
        "type", // Group by 'type'
        "calories", // Aggregate 'calories'
        filters: [
          filterCaloriesGreaterThan500
        ], // Apply filter to include only meals with calories > 500
      );

      // Expected aggregation result with the filter applied
      var expectedAggregationWithFilter = {
        "Non-Vegetarian": {
          "count": 2,
          "sum": 1500,
          "average": 750.0,
          "min": 700,
          "max": 800
        },
        "Vegetarian": {
          "count": 1,
          "sum": 600,
          "average": 600.0,
          "min": 600,
          "max": 600
        }
      };

      expect(aggregation, equals(expectedAggregationWithFilter));

      if (kDebugMode) {
        print(aggregation);
      }
    });
  });
}
