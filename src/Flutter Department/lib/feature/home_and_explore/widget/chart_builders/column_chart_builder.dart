import 'package:flutter/material.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/chart_helpers.dart';
import 'package:InsightHub/feature/home_and_explore/widget/safe_error_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPalette {
  const ChartPalette._();

  static const Color brownGold = Color(0xFF004AAD);
  static const Color warmOrange = Color(0xFF38B6FF);
  static const Color softLime = Color(0xFF5271FF);
  static const Color sageGreen = Color(0xFFBDE0FE);
  static const Color forestGreen = Color(0xFF004AAD);
}

class ChartStyles {
  const ChartStyles._();

  static const double selectableChartHeight = 320;
  static const double roundedBarRadius = 14;
  static const double barSpacing = 0.22;
  static const double barWidth = 0.55;

  static const EdgeInsets columnChartMargin = EdgeInsets.fromLTRB(
    12,
    20,
    12,
    12,
  );

  static TooltipBehavior tooltipBehavior({
    String? format,
  }) {
    return TooltipBehavior(
      enable: true,
      format: format,
      color: ChartPalette.forestGreen,
      elevation: 0,
      canShowMarker: false,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static CategoryAxis categoryAxis() {
    return CategoryAxis(
      majorGridLines: const MajorGridLines(width: 0),
      axisLine: const AxisLine(width: 0),
      majorTickLines: const MajorTickLines(size: 0),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: ChartPalette.forestGreen,
      ),
    );
  }

  static NumericAxis hiddenNumericAxis() {
    return NumericAxis(
      isVisible: false,
      majorGridLines: const MajorGridLines(width: 0),
      axisLine: const AxisLine(width: 0),
      majorTickLines: const MajorTickLines(size: 0),
    );
  }

 static Color selectablePointColor(
  int? index,
  int? selectedIndex,
) {
  final colors = [
    ChartPalette.brownGold,
    ChartPalette.warmOrange,
    ChartPalette.sageGreen,
    ChartPalette.forestGreen,
  ];

  final baseColor = colors[index! % colors.length];

  if (selectedIndex == null) {
    return baseColor;
  }

  return index == selectedIndex
      ? baseColor
      : baseColor.withOpacity(0.25);
}
  static const TextStyle dataLabelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: ChartPalette.forestGreen,
  );
}

class ColumnChartBuilder {
  const ColumnChartBuilder._();

  static Widget build(List<Map<String, dynamic>> rawData) {
    try {
      if (rawData.isEmpty) {
        return const SafeErrorWidget(
          message: 'No data available',
        );
      }

      int? selectedIndex;

      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: ChartPalette.softLime.withOpacity(0.5),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  color: ChartPalette.forestGreen.withOpacity(0.08),
                ),
              ],
            ),
            child: SizedBox(
              height: ChartStyles.selectableChartHeight,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                margin: ChartStyles.columnChartMargin,
                backgroundColor: Colors.transparent,
                tooltipBehavior: ChartStyles.tooltipBehavior(
                  format: 'point.x : point.y',
                ),
                primaryXAxis: ChartStyles.categoryAxis(),
                primaryYAxis: ChartStyles.hiddenNumericAxis(),
                series: [
                  _buildSeries(
                    rawData,
                    selectedIndex,
                    (int? nextIndex) {
                      setState(() {
                        selectedIndex = nextIndex;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (_) {
      return const SafeErrorWidget(
        message: 'Column chart failed',
      );
    }
  }

  static ColumnSeries<Map<String, dynamic>, String> _buildSeries(
    List<Map<String, dynamic>> rawData,
    int? selectedIndex,
    ValueChanged<int?> onSelectionChanged,
  ) {
    return ColumnSeries<Map<String, dynamic>, String>(
      animationDuration: 900,
      spacing: ChartStyles.barSpacing,
      width: ChartStyles.barWidth,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(
          ChartStyles.roundedBarRadius,
        ),
      ),
      dataSource: rawData,

      xValueMapper: (data, index) {
        return ChartHelpers.selectedAwareLabel(
          data,
          index,
          selectedIndex,
        );
      },

      yValueMapper: (data, _) {
        return ChartHelpers.value(data);
      },

      pointColorMapper: (data, index) {
        return ChartStyles.selectablePointColor(
          index,
          selectedIndex,
        );
      },

      dataLabelSettings: const DataLabelSettings(
        isVisible: true,
        labelPosition: ChartDataLabelPosition.outside,
        textStyle: ChartStyles.dataLabelStyle,
      ),

      dataLabelMapper: (data, _) {
        return ChartHelpers.compactNumber(
          ChartHelpers.value(data),
        );
      },

      onPointTap: (details) {
        onSelectionChanged(
          ChartHelpers.toggledSelection(
            details.pointIndex,
            selectedIndex,
          ),
        );
      },
    );
  }
}