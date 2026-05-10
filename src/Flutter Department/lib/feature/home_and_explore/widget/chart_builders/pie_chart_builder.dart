import 'package:flutter/material.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/chart_helpers.dart';
import 'package:InsightHub/feature/home_and_explore/widget/safe_error_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartBuilder {
  const PieChartBuilder._();

  static Widget build(List<Map<String, dynamic>> rawData) {
    try {
      if (rawData.isEmpty) {
        return const SafeErrorWidget(message: 'No data available');
      }

      return SfCircularChart(
        series: [
          PieSeries<Map<String, dynamic>, String>(
            animationDuration: 0,
            dataSource: rawData,
            xValueMapper: (data, _) => ChartHelpers.label(data),
            yValueMapper: (data, _) => ChartHelpers.value(data),
            dataLabelSettings: const DataLabelSettings(isVisible: false),
          ),
        ],
      );
    } catch (_) {
      return const SafeErrorWidget(message: 'Pie chart failed');
    }
  }
}
