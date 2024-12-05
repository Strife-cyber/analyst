import 'package:analyst/algorithms/data_cluster.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KMeans Clustering Test', () {
    test('Text KMeans Clustering with simple data', () {
      // Simple dataset with 2D points
      var data = [
        [1.0, 2.0],
        [1.5, 1.8],
        [5.0, 8.0],
        [8.0, 8.0],
        [1.0, 0.6],
        [9.0, 11.0],
      ];

      var kMeans = KMeans();
      var centroids = kMeans.fit(data, 2);

      // Expect 2 centroids (as we have k=2)
      expect(centroids.length, equals(2));
      expect(centroids[0].length,
          equals(2)); // Each centroid should have 2 values (2D points)
      expect(centroids[1].length, equals(2));

      // Additional assertions can be added based on expected centroid locations
      expect(centroids[0][0], isNot(equals(centroids[1][0])));
    });

    test('Test KMeans with one cluster', () {
      var data = [
        [1.0, 2.0],
        [1.5, 1.8],
        [1.0, 0.6],
      ];

      var kMeans = KMeans();
      var centroids = kMeans.fit(data, 1); // k = 1

      // With only one cluster, centroids should be close to the average of points
      expect(centroids.length, equals(1));
      expect(centroids[0], isNotEmpty);
      expect(centroids[0][0], closeTo(1.17, 0.1)); // Approximate centroid value
    });
  });

  group('DBSCAN Clustering', () {
    test('Test DBSCAN with noise', () {
      var data = [
        [1.0, 2.0],
        [1.5, 1.8],
        [5.0, 8.0],
        [8.0, 8.0],
        [1.0, 0.6],
        [9.0, 11.0],
      ];

      var dbscan = DBSCAN(epsilon: 3.0, minPts: 2); // Define epsilon and minPts
      var labels = dbscan.fit(data);

      // Points 0, 1, 4 and 5 should be part of the same cluster
      expect(labels[0], equals(1));
      expect(labels[1], equals(1));
      expect(labels[4], equals(1));

      // Points 2 and 3 should be in separate clusters
      expect(labels[2], isNot(equals(-1))); // Marked as noise
      expect(labels[3], isNot(equals(-1))); // Marked as noise

      // Point 5 should be noise
      expect(labels[5], equals(-1));
    });

    test('Test DBSCAN with a single cluster', () {
      var data = [
        [1.0, 2.0],
        [1.5, 1.8],
        [1.0, 0.6],
      ];

      var dbscan = DBSCAN(epsilon: 1.5, minPts: 2);
      var labels = dbscan.fit(data);

      // All points should belong to the same cluster
      expect(labels[0], equals(1));
      expect(labels[1], equals(1));
      expect(labels[2], equals(1));
    });
  });
}
