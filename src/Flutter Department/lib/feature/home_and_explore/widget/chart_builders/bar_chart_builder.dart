import 'package:flutter/material.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/chart_helpers.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/chart_styles.dart';
import 'package:InsightHub/feature/home_and_explore/widget/safe_error_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartBuilder {
  const BarChartBuilder._();
static const List<Color> chartColors = [
    Color(0xFF004AAD), 
    Color(0xFF38B6FF), 
    Color(0xFF5271FF), 
    Color(0xFFBDE0FE), 
    Color.fromARGB(255, 216, 238, 253), 
  ];
  static Widget build(List<Map<String, dynamic>> rawData) {
    try {
      if (rawData.isEmpty) {
        return const SafeErrorWidget(message: 'No data available');
      }

      int? selectedIndex;

      return StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: ChartStyles.selectableChartHeight,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              margin: ChartStyles.barChartMargin,
              tooltipBehavior: ChartStyles.tooltipBehavior(
                format: 'point.x : point.y',
              ),
              
              primaryXAxis: CategoryAxis(
                isInversed: true,
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                axisLine: const AxisLine(width: .5, color: Color(0xFFE5E7EB)),
                labelRotation: -45,
                labelIntersectAction: AxisLabelIntersectAction.rotate45,
                maximumLabelWidth: 80,
                labelStyle: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),

              primaryYAxis: const NumericAxis(
                isVisible: false,
                majorGridLines: MajorGridLines(width: 0),
                rangePadding: ChartRangePadding.normal,
              ),

              series: [
                _buildSeries(
                  rawData,
                  selectedIndex,
                  (int? nextIndex) => setState(() {
                    selectedIndex = nextIndex;
                  }),
                ),
              ],
            ),
          );
        },
      );
    } catch (_) {
      return const SafeErrorWidget(message: 'Bar chart failed');
    }
  }

  static BarSeries<Map<String, dynamic>, String> _buildSeries(
    List<Map<String, dynamic>> rawData,
    int? selectedIndex,
    ValueChanged<int?> onSelectionChanged,
  ) {
    return BarSeries<Map<String, dynamic>, String>(
      animationDuration: 1000,
      borderRadius: const BorderRadius.horizontal(
        right: Radius.circular(ChartStyles.roundedBarRadius),
      ),
      spacing: ChartStyles.barSpacing,
      width: ChartStyles.barWidth,
      dataSource: rawData,
      xValueMapper: (data, index) {
        return ChartHelpers.selectedAwareLabel(data, index, selectedIndex);
      },
      yValueMapper: (data, _) => ChartHelpers.value(data),
    pointColorMapper: (data, index) {
  final baseColor =
      chartColors[index % chartColors.length];

  if (selectedIndex == null) {
    return baseColor;
  }

  return index == selectedIndex
      ? baseColor
      : baseColor.withOpacity(0.25);
},
      dataLabelSettings: const DataLabelSettings(
        isVisible: true,
        labelPosition: ChartDataLabelPosition.outside,
        textStyle: ChartStyles.dataLabelStyle,
      ),
      dataLabelMapper: (data, _) {
        return ChartHelpers.compactNumber(ChartHelpers.value(data));
      },
      onPointTap: (details) {
        onSelectionChanged(
          ChartHelpers.toggledSelection(details.pointIndex, selectedIndex),
        );
      },
    );
  }
}