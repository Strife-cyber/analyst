import 'package:flutter/material.dart';

class DatasetJsonTree extends StatefulWidget {
  final List<Map<String, dynamic>> dataset;

  const DatasetJsonTree({required this.dataset, super.key});

  @override
  State<DatasetJsonTree> createState() => _DatasetJsonTreeState();
}

class _DatasetJsonTreeState extends State<DatasetJsonTree>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Set up the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Simulate loading with a delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const SizedBox(
            height: 400,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
              ),
            ),
          )
        : FadeTransition(
            opacity: _animation,
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              shrinkWrap: true,
              itemCount: widget.dataset.length,
              itemBuilder: (context, index) {
                final row = widget.dataset[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildJsonTree(row, 'Item ${index + 1}'),
                  ),
                );
              },
            ),
          );
  }

  /// Builds a JSON tree recursively with beautiful green accents.
  Widget _buildJsonTree(dynamic data, String key) {
    if (data is Map<String, dynamic>) {
      return SingleChildScrollView(
        child: ExpansionTile(
          title: Text(
            key,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[500]!,
            ),
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[400]!,
            ),
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[300]!,
            ),
          ),
          subtitle: Text(
            data.toString(),
            style: const TextStyle(color: Colors.black45),
          ),
        ),
      );
    }
  }
}
