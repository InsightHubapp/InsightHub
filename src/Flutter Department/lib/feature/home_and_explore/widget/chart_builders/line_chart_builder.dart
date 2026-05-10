import 'package:flutter/material.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/chart_helpers.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/chart_styles.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/widgets/custom_badge_widget.dart';
import 'package:InsightHub/feature/home_and_explore/widget/safe_error_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartBuilder {
  const LineChartBuilder._();

  static Widget build(List<Map<String, dynamic>> rawData) {
    try {
      if (rawData.isEmpty) {
        return const SafeErrorWidget(message: 'No data available');
      }

      return Container(
        height: ChartStyles.compactChartHeight,
        padding: ChartStyles.lineContainerPadding,
        child: SfCartesianChart(
          margin: ChartStyles.lineChartMargin,
          plotAreaBorderWidth: 0,
          enableAxisAnimation: true,
          tooltipBehavior: ChartStyles.tooltipBehavior(
            color: Colors.black87,
            textStyle: ChartStyles.lineTooltipTextStyle,
          ),
          primaryXAxis: ChartStyles.categoryAxis(
            labelStyle: ChartStyles.axisLabelStyle,
            axisWidth: 1.2,
          ),
          primaryYAxis: ChartStyles.lineNumericAxis(),
          series: [_buildAreaSeries(rawData), _buildSplineSeries(rawData)],
        ),
      );
    } catch (_) {
      return const SafeErrorWidget(message: 'Line chart failed');
    }
  }

 
  static AreaSeries<Map<String, dynamic>, String> _buildAreaSeries(
    List<Map<String, dynamic>> rawData,
  ) {
    return AreaSeries<Map<String, dynamic>, String>(
      dataSource: rawData,
      xValueMapper: (data, _) => ChartHelpers.label(data),
      yValueMapper: (data, _) => ChartHelpers.value(data),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          ChartStyles.primaryChartColor.withValues(alpha: 0.30),
          ChartStyles.primaryChartColor.withValues(alpha: 0.01),
        ],
      ),
      borderWidth: 0,
      animationDuration: 1400,
    );
  }

  static SplineSeries<Map<String, dynamic>, String> _buildSplineSeries(
    List<Map<String, dynamic>> rawData,
  ) {
    return SplineSeries<Map<String, dynamic>, String>(
      animationDuration: 1400,
      dataSource: rawData,
      xValueMapper: (data, _) => ChartHelpers.label(data),
      yValueMapper: (data, _) => ChartHelpers.value(data),
      color: ChartStyles.primaryChartColor,
      width: 4,
      splineType: SplineType.monotonic,
      enableTooltip: true,
      markerSettings: const MarkerSettings(isVisible: false),
      dataLabelSettings: DataLabelSettings(
        isVisible: true,
        labelAlignment: ChartDataLabelAlignment.top,
        labelPosition: ChartDataLabelPosition.outside,
        margin: const EdgeInsets.only(bottom: 15),
        builder:
            (
              dynamic data,
              dynamic point,
              dynamic series,
              int pointIndex,
              int seriesIndex,
            ) {
              final value = ChartHelpers.value(data as Map<String, dynamic>);
              return CustomBadgeWidget(
                value: value % 1 == 0
                    ? value.toInt().toString()
                    : value.toString(),
                color: ChartStyles.primaryChartColor,
              );
            },
      ),
    );
  }
}
