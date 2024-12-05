import 'dart:math';

class KMeans {
  double _euclideanDistance(List<double> a, List<double> b) {
    double sum = 0;
    for (int i = 0; i < a.length; i++) {
      sum += (a[i] - b[i]) * (a[i] - b[i]);
    }
    return sqrt(sum);
  }

  bool _centroidsEqual(
      List<List<double>> oldCentroids, List<List<double>> centroids) {
    for (var i = 0; i < oldCentroids.length; i++) {
      for (var j = 0; j < oldCentroids[i].length; j++) {
        if ((oldCentroids[i][j] - centroids[i][j]).abs() > 0.0001) {
          return false;
        }
      }
    }
    return true;
  }

  List<List<double>> fit(List<List<double>> data, int k,
      {int maxIterations = 100}) {
    // Step 1: Randomly initialize centroids
    var random = Random();
    List<List<double>> centroids = List.generate(k, (index) {
      return List.generate(data[0].length, (i) => random.nextDouble());
    });

    List<List<double>> oldCentroids =
        List.generate(k, (index) => List<double>.filled(data[0].length, 0.0));

    List<int> labels = List.filled(data.length, 0);
    int iteration = 0;

    // Iterate to find centroids
    while (!_centroidsEqual(oldCentroids, centroids) &&
        iteration < maxIterations) {
      oldCentroids =
          List<List<double>>.from(centroids.map((e) => List<double>.from(e)));

      // Step 2: Assign points to the nearest centroid
      for (var i = 0; i < data.length; i++) {
        double minDistance = double.infinity;
        int label = 0;
        for (var j = 0; j < k; j++) {
          var distance = _euclideanDistance(data[i], centroids[j]);
          if (distance < minDistance) {
            minDistance = distance;
            label = j;
          }
        }
        labels[i] = label;
      }

      // Step 3: Update centroids
      List<List<double>> sums =
          List.generate(k, (_) => List<double>.filled(data[0].length, 0.0));
      var counts = List.filled(k, 0);

      for (var i = 0; i < data.length; i++) {
        for (var j = 0; j < data[i].length; j++) {
          sums[labels[i]][j] += data[i][j];
        }
        counts[labels[i]]++;
      }

      for (var i = 0; i < k; i++) {
        for (var j = 0; j < sums[i].length; j++) {
          if (counts[i] > 0) {
            centroids[i][j] = sums[i][j] / counts[i];
          }
        }
      }

      iteration++;
    }

    return centroids;
  }
}

class DBSCAN {
  final double epsilon;
  final int minPts;

  DBSCAN({required this.epsilon, required this.minPts});

  double _euclideanDistance(List<double> a, List<double> b) {
    double sum = 0;
    for (var i = 0; i < a.length; i++) {
      sum += (a[i] - b[i]) * (a[i] - b[i]);
    }
    return sqrt(sum);
  }

  List<int> _regionQuery(List<List<double>> data, int pointIndex) {
    List<int> neighbors = [];
    for (int i = 0; i < data.length; i++) {
      if (_euclideanDistance(data[pointIndex], data[i]) <= epsilon) {
        neighbors.add(i);
      }
    }
    return neighbors;
  }

  void _expandCluster(List<List<double>> data, List<int> labels, int pointIndex,
      List<int> neighbors, int clusterId) {
    labels[pointIndex] = clusterId;
    List<int> seeds = List.from(neighbors);
    seeds.remove(pointIndex);

    while (seeds.isNotEmpty) {
      int currentPoint = seeds.removeAt(0);

      if (labels[currentPoint] == -1) {
        // Noise point; recheck its neighbors before assigning it to the cluster
        var newNeighbors = _regionQuery(data, currentPoint);
        if (newNeighbors.length >= minPts) {
          labels[currentPoint] = clusterId;
        }
      }

      if (labels[currentPoint] == 0) {
        // Unvisited point, expand cluster
        labels[currentPoint] = clusterId;
        var newNeighbors = _regionQuery(data, currentPoint);
        if (newNeighbors.length >= minPts) {
          // Add only unique neighbors
          for (var neighbor in newNeighbors) {
            if (!seeds.contains(neighbor)) {
              seeds.add(neighbor);
            }
          }
        }
      }
    }
  }

  List<int> fit(List<List<double>> data) {
    int n = data.length;
    List<int> labels = List.filled(n, 0); // 0 means unvisited
    int clusterId = 0;

    for (int i = 0; i < n; i++) {
      if (labels[i] != 0) continue; // Skip visited points

      var neighbors = _regionQuery(data, i);
      if (neighbors.length >= minPts) {
        clusterId++;
        _expandCluster(data, labels, i, neighbors, clusterId);
      } else {
        labels[i] = -1; // Mark as noise
      }
    }

    return labels;
  }
}
