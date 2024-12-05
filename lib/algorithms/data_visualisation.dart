import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum ChartType { bar, line, scatter }

class DataVisualisation extends StatelessWidget {
  final List<Map<String, dynamic>> dataset;
  final String xField;
  final String yField;
  final String? categoryField;
  final ChartType chartType;

  const DataVisualisation({
    super.key,
    required this.dataset,
    required this.xField,
    required this.yField,
    this.categoryField,
    required this.chartType,
  });

  Widget _buildBarChart() {
    List<BarChartGroupData> barData = dataset.map((item) {
      final xValue = item[xField];
      final yValue = item[yField];

      if (xValue is int && yValue is num) {
        return BarChartGroupData(
          x: xValue,
          barRods: [
            BarChartRodData(
              toY: yValue.toDouble(),
              color: Colors.blue,
              width: 20,
            ),
          ],
        );
      }
      return BarChartGroupData(x: 0, barRods: []); // Fallback for invalid data
    }).toList();

    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: true),
        gridData: const FlGridData(show: true),
        barGroups: barData,
      ),
    );
  }

  Widget _buildLineChart() {
    List<FlSpot> spots = dataset.map((item) {
      final xValue = item[xField];
      final yValue = item[yField];

      if (xValue is num && yValue is num) {
        return FlSpot(xValue.toDouble(), yValue.toDouble());
      }
      return const FlSpot(0, 0); // Fallback for invalid data
    }).toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.green,
          ),
        ],
        titlesData: const FlTitlesData(show: true),
        gridData: const FlGridData(show: true),
      ),
    );
  }

  Widget _buildScatterPlot() {
    List<ScatterSpot> scatterData = dataset.map((item) {
      final xValue = item[xField];
      final yValue = item[yField];

      if (xValue is num && yValue is num) {
        return ScatterSpot(xValue.toDouble(), yValue.toDouble());
      }
      return ScatterSpot(0, 0); // Fallback for invalid data
    }).toList();

    return ScatterChart(
      ScatterChartData(
        scatterSpots: scatterData,
        gridData: const FlGridData(show: true),
      ),
    );
  }

  Widget _buildChart() {
    switch (chartType) {
      case ChartType.bar:
        return _buildBarChart();
      case ChartType.line:
        return _buildLineChart();
      case ChartType.scatter:
        return _buildScatterPlot();
      default:
        return const Center(child: Text("Unsupported chart type"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Data Visualization'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 400, // Set a fixed height for the chart
              child: _buildChart(),
            ),
          ],
        ),
      ),
    );
  }
}
