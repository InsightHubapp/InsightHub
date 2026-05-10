import 'package:flutter/material.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/bar_chart_builder.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/column_chart_builder.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/doughnut_chart_builder.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/line_chart_builder.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/pie_chart_builder.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/treemap_chart_builder.dart';

class ChartBuilders {
  const ChartBuilders._();

  static Widget buildLineChart(List<Map<String, dynamic>> rawData) {
    return LineChartBuilder.build(rawData);
  }

  static Widget buildBarChart(List<Map<String, dynamic>> rawData) {
    return BarChartBuilder.build(rawData);
  }

  static Widget buildColumnChart(List<Map<String, dynamic>> rawData) {
    return ColumnChartBuilder.build(rawData);
  }

  static Widget buildDoughnutChart(List<Map<String, dynamic>> rawData) {
    return DoughnutChartBuilder.build(rawData);
  }

  static Widget buildPieChart(List<Map<String, dynamic>> rawData) {
    return PieChartBuilder.build(rawData);
  }

  static Widget buildTreemap(List<Map<String, dynamic>> rawData) {
    return TreemapChartBuilder.build(rawData);
  }

 
}
