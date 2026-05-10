import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/chart_helpers.dart';
import 'package:InsightHub/feature/home_and_explore/widget/chart_builders/chart_styles.dart';
import 'package:InsightHub/feature/home_and_explore/widget/safe_error_widget.dart';
import 'package:syncfusion_flutter_treemap/treemap.dart';

class TreemapChartBuilder {
  const TreemapChartBuilder._();

  static Widget build(List<Map<String, dynamic>> rawData) {
    try {
      if (rawData.isEmpty) {
        return const SafeErrorWidget(message: 'No data available');
      }

      final maxWeight = ChartHelpers.maxValue(rawData);
      final dynamicHeight = ChartHelpers.dynamicChartHeight(rawData.length);

      return Container(
        height: dynamicHeight,
        padding: ChartStyles.treemapPadding,
        child: SfTreemap(
          dataCount: rawData.length,
          weightValueMapper: (index) => ChartHelpers.value(rawData[index]),
          levels: [
            TreemapLevel(
              groupMapper: (index) => ChartHelpers.label(rawData[index]),
              colorValueMapper: (tile) => _tileColor(tile, maxWeight),
              labelBuilder: _buildLabel,
            ),
          ],
        ),
      );
    } catch (_) {
      return const SafeErrorWidget(message: 'Treemap failed');
    }
  }

  static Color _tileColor(TreemapTile tile, double maxWeight) {
    final ratio = (tile.weight / maxWeight).clamp(0.0, 1.0);
    if (ratio < 0.5) {
      return Color.lerp(
            ChartStyles.treemapLowColor,
            ChartStyles.treemapMidColor,
            ratio * 2,
          ) ??
          ChartStyles.treemapLowColor;
    }

    return Color.lerp(
          ChartStyles.treemapMidColor,
          ChartStyles.treemapHighColor,
          (ratio - 0.5) * 2,
        ) ??
        ChartStyles.treemapMidColor;
  }

  static Widget _buildLabel(BuildContext context, TreemapTile tile) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tile.group,
              style: const TextStyle(
                color: AppColors.bgWhite,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 4),
            Text(
              tile.weight.toInt().toString(),
              style: TextStyle(
                color: AppColors.bgWhite.withValues(alpha: 0.9),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
