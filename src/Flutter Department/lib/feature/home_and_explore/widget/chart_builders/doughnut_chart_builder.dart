import 'package:flutter/material.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/chart_helpers.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/chart_styles.dart';
import 'package:InsightHub/feature/home_and_explore/widget/safe_error_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnutChartBuilder {
  const DoughnutChartBuilder._();

  // ===== HIGH CONTRAST PROFESSIONAL PALETTE =====
static const List<Color> chartColors = [
    Color(0xFF004AAD), // Principal
    Color(0xFF38B6FF), // Lead
    Color(0xFF5271FF), // Senior
    Color(0xFFBDE0FE), // Trainee
  ];

  static Widget build(List<Map<String, dynamic>> rawData) {
    try {
      if (rawData.isEmpty) {
        return const SafeErrorWidget(
          message: 'No data available',
        );
      }

      final total = ChartHelpers.totalValue(rawData);

      bool showRealValues = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return SfCircularChart(
            margin: const EdgeInsets.all(10),

            legend: const Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
              textStyle: ChartStyles.legendTextStyle,
            ),

            tooltipBehavior: TooltipBehavior(
              enable: true,
              color: const Color(0xFF001D3D),
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),

            onDataLabelTapped: (_) {
              setState(() {
                showRealValues = !showRealValues;
              });
            },

            series: [
              DoughnutSeries<Map<String, dynamic>, String>(
                animationDuration: 1000,

                dataSource: rawData,

                xValueMapper: (data, _) {
                  return ChartHelpers.label(data);
                },

                yValueMapper: (data, _) {
                  return ChartHelpers.value(data);
                },

                pointColorMapper: (_, index) {
                  return chartColors[
                      index! % chartColors.length];
                },

                dataLabelMapper: (data, _) {
                  return _formatLabel(
                    data,
                    total,
                    showRealValues,
                  );
                },

                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition:
                      ChartDataLabelPosition.outside,
                  textStyle:
                      ChartStyles.circularDataLabelStyle,
                  useSeriesColor: true,
                ),

                innerRadius: '60%',

               radius: '80%',

                explode: true,
                explodeOffset: '4%',
                explodeAll: false,

                strokeWidth: 3,
                strokeColor: Colors.white,
              ),
            ],
          );
        },
      );
    } catch (_) {
      return const SafeErrorWidget(
        message: 'Doughnut chart failed',
      );
    }
  }

  static String _formatLabel(
    Map<String, dynamic> data,
    double total,
    bool showRealValues,
  ) {
    final value = ChartHelpers.value(data);

    if (showRealValues) {
      return value.toInt().toString();
    }

    final ratio = (value / total * 100)
        .toStringAsFixed(1);

    return '$ratio%';
  }
}