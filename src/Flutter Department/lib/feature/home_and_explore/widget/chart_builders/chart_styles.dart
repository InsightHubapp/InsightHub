import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartStyles {
  const ChartStyles._();

  static const Color primaryChartColor =     Color(0xFF004AAD) // Principal
;
  static const Color axisBorderColor = AppColors.border;
  static const Color mutedAxisLabelColor = Color(0xFF9CA3AF);
  static const Color activeAxisLabelColor = AppColors.textPrimary;
  static const Color tooltipTextColor = AppColors.bgWhite;
  static const Color treemapLowColor = Color(0xFF4DB6AC);
  static const Color treemapMidColor = Color(0xFF38B6FF);
  static const Color treemapHighColor = Color(0xFF004AAD);

  static const double compactChartHeight = 320;
  static const double selectableChartHeight = 420;
  static const double selectedOpacity = 1;
  static const double fadedOpacity = 0.18;
  static const double barWidth = 0.52;
  static const double barSpacing = 0.1;
  static const double roundedBarRadius = 10;
  static const double badgeRadius = 8;

  static const EdgeInsets lineContainerPadding = EdgeInsets.only(
    top: 12,
    right: 8,
  );
  static const EdgeInsets lineChartMargin = EdgeInsets.only(
    top: 10,
    bottom: 0,
    left: 0,
    right: 8,
  );
  static const EdgeInsets barChartMargin = EdgeInsets.fromLTRB(8, 16, 40, 8);
  static const EdgeInsets columnChartMargin = EdgeInsets.fromLTRB(8, 30, 8, 8);
  static const EdgeInsets treemapPadding = EdgeInsets.symmetric(vertical: 8);

  static const TextStyle axisLabelStyle = TextStyle(
    fontSize: 10,
    color: mutedAxisLabelColor,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle selectedAxisLabelStyle = TextStyle(
    fontSize: 11,
    color: activeAxisLabelColor,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle tooltipTextStyle = TextStyle(
    color: tooltipTextColor,
    fontWeight: FontWeight.w600,
    fontSize: 12,
  );

  static const TextStyle lineTooltipTextStyle = TextStyle(
    color: tooltipTextColor,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle dataLabelStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: primaryChartColor,
  );

  static const TextStyle circularDataLabelStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle legendTextStyle = TextStyle(fontSize: 10);

  static MajorGridLines horizontalGridLines() {
    return MajorGridLines(width: 1, color: Colors.grey.withValues(alpha: 0.10));
  }

  static Color selectablePointColor(int index, int? selectedIndex) {
    if (selectedIndex == null) return primaryChartColor;
    return selectedIndex == index
        ? primaryChartColor
        : primaryChartColor.withValues(alpha: fadedOpacity);
  }

  static TooltipBehavior tooltipBehavior({
    Color? color,
    TextStyle? textStyle,
    String? format,
  }) {
    return TooltipBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      canShowMarker: false,
      header: '',
      format: format,
      color: color ?? primaryChartColor.withValues(alpha: 0.92),
      textStyle: textStyle ?? tooltipTextStyle,
    );
  }

  static CategoryAxis categoryAxis({
    TextStyle labelStyle = selectedAxisLabelStyle,
    double axisWidth = 0.5,
    bool rotateLabels = true,
  }) {
    return CategoryAxis(
      majorGridLines: const MajorGridLines(width: 0),
      majorTickLines: const MajorTickLines(size: 0),
      axisLine: AxisLine(width: axisWidth, color: axisBorderColor),
      labelRotation: rotateLabels ? -45 : 0,
      labelIntersectAction: rotateLabels
          ? AxisLabelIntersectAction.rotate45
          : AxisLabelIntersectAction.none,
      labelStyle: labelStyle,
    );
  }

  static NumericAxis hiddenNumericAxis() {
    return const NumericAxis(
      isVisible: false,
      majorGridLines: MajorGridLines(width: 0),
      rangePadding: ChartRangePadding.additional,
    );
  }

  static NumericAxis lineNumericAxis() {
    return NumericAxis(
      labelStyle: const TextStyle(color: Colors.transparent),
      axisLine: const AxisLine(width: 0),
      majorTickLines: const MajorTickLines(size: 0),
      majorGridLines: horizontalGridLines(),
      rangePadding: ChartRangePadding.additional,
      numberFormat: NumberFormat.compact(),
    );
  }
}
