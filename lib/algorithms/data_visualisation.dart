import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum ChartType { bar, line, scatter }

class DataVisualisation extends StatelessWidget {
  final List<Map<String, dynamic>> dataset;
  final String xField;
  final String yField;
  final String? categoryField;
  final ChartType chartType;

  const DataVisualisation(
      {super.key,
      required this.dataset,
      required this.xField,
      required this.yField,
      this.categoryField,
      required this.chartType});

  Widget _buildBarChart() {
    List<BarChartGroupData> barData = dataset.map((item) {
      return BarChartGroupData(x: item[xField], barRods: [
        BarChartRodData(
            toY: item[yField].toDouble(), color: Colors.blue, width: 20)
      ]);
    }).toList();

    return BarChart(BarChartData(
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: true),
        gridData: const FlGridData(show: true),
        barGroups: barData));
  }

  Widget _buildLineChart() {
    List<LineChartBarData> lineData = [
      LineChartBarData(
          spots: dataset.map((item) {
            return FlSpot(item[xField].toDouble(), item[yField].toDouble());
          }).toList(),
          isCurved: true,
          color: Colors.green),
    ];

    return LineChart(
      LineChartData(
        lineBarsData: lineData,
        titlesData: const FlTitlesData(show: true),
        gridData: const FlGridData(show: true),
      ),
    );
  }

  Widget _buildScatterPlot() {
    List<ScatterSpot> scatterData = dataset.map((item) {
      return ScatterSpot(item[xField].toDouble(), item[yField].toDouble());
    }).toList();

    return ScatterChart(
      ScatterChartData(
        scatterSpots: scatterData,
        gridData: const FlGridData(show: true),
      ),
    );
  }

  Widget _buildChart(List<Map<String, dynamic>> data) {
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
            _buildChart(dataset),
          ],
        ),
      ),
    );
  }
}
