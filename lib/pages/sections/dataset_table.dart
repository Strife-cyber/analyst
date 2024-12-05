import 'package:flutter/material.dart';

class DatasetJsonTree extends StatelessWidget {
  final List<Map<String, dynamic>> dataset;

  const DatasetJsonTree({required this.dataset, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      shrinkWrap: true,
      itemCount: dataset.length,
      itemBuilder: (context, index) {
        final row = dataset[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildJsonTree(row, 'Item ${index + 1}'),
          ),
        );
      },
    );
  }

  /// Builds a JSON tree recursively.
  Widget _buildJsonTree(dynamic data, String key) {
    if (data is Map<String, dynamic>) {
      return SingleChildScrollView(
        child: ExpansionTile(
          title: Text(
            key,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          children: data.entries
              .map((entry) => _buildJsonTree(entry.value, entry.key))
              .toList(),
        ),
      );
    } else if (data is List) {
      return SingleChildScrollView(
        child: ExpansionTile(
          title: Text(
            key,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          children: data
              .asMap()
              .entries
              .map((entry) => _buildJsonTree(entry.value, '[${entry.key}]'))
              .toList(),
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ListTile(
          title: Text(
            key,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(data.toString()),
        ),
      );
    }
  }
}
