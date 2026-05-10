import 'package:flutter/material.dart';
import 'package:InsightHub/feature/home_and_explore/widget/dynamic_card.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/chart_builders.dart';
import 'package:InsightHub/feature/home_and_explore/widget/safe_error_widget.dart';

typedef WidgetBuilderFn = Widget Function(dynamic data);

class WidgetFactory {
  static final Map<String, WidgetBuilderFn> _builders = {
    /// Cards
    "cards": (data) =>
        DynamicCard(data: data is Map<String, dynamic> ? data : null),

    /// Charts
    "line": (data) => ChartBuilders.buildLineChart(_extractList(data)),
    "bar": (data) => ChartBuilders.buildBarChart(_extractList(data)),
    "pie": (data) => ChartBuilders.buildPieChart(_extractList(data)),
    "doughnut": (data) => ChartBuilders.buildDoughnutChart(_extractList(data)),
    "treemap": (data) => ChartBuilders.buildTreemap(_extractList(data)),
    "column": (data) => ChartBuilders.buildColumnChart(_extractList(data)),
    // "multiple bar": (data) => ChartBuilders.buildGroupedBarChart(_extractList(data)),
  };

  static Widget build(String type, dynamic data) {
    try {
      final builder = _builders[_normalize(type)];

      if (builder != null) {
        return builder(data);
      }

      return SafeErrorWidget(message: "Unknown type: $type");
    } catch (e) {
      return const SafeErrorWidget(message: "Render failed");
    }
  }

  static String _normalize(String type) {
    switch (type.toLowerCase().trim()) {
      case "card":
        return "cards";
      case "column":
      case "vertical bar":
        return "column";
      case "grouped bar":
      case "multiple bar":
        return "multiple bar";
      case "treemap":
        return "treemap";
      case "doughnut":
      case "donut":
        return "doughnut";
      default:
        return type.toLowerCase().trim();
    }
  }

  /// 🔥 extract list from map['data']
  static List<Map<String, dynamic>> _extractList(dynamic data) {
    if (data is Map<String, dynamic>) {
      final list = data['data'];
      if (list is List) {
        return list
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    }

    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    return [];
  }
}
