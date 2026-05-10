import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/core/utils/safe_parser.dart';
import 'package:InsightHub/feature/home_and_explore/widget/safe_error_widget.dart';

class DynamicCard extends StatelessWidget {
  final Map<String, dynamic>? data;

  const DynamicCard({super.key, required this.data});

  static IconData _iconForSuffix(String suffix) {
    switch (suffix.toLowerCase().trim()) {
      case 'jobs':
        return Icons.work_outline_rounded;
      case '/h':
      case 'jobs/h':
        return Icons.schedule_rounded;
      case '%':
        return Icons.pie_chart_outline_rounded;
      case 'x':
        return Icons.trending_up_rounded;
      default:
        return Icons.insights_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    try {
      if (data == null || data!.isEmpty) {
        return const SafeErrorWidget(message: 'No data provided');
      }

      final rawValue = data!['data'];
      final value = rawValue?.toString() ?? '0';
      final suffix = SafeParser.getString(data, 'suffix');
      final trend = SafeParser.getString(data, 'trend').toLowerCase().trim();
      final hasPositiveTrend = trend == 'up';
      final hasNegativeTrend = trend == 'down';

      final title = SafeParser.getString(data, 'title');
      final objective = SafeParser.getString(data, 'objective');

    

      final icon = _iconForSuffix(suffix);
      final trendColor = hasPositiveTrend ? AppColors.success : Colors.red;

      return Padding(
        padding: const EdgeInsets.only(left: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── TOP: Rounded icon container ───────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, size: 24, color: AppColors.primary),
            ),

            const SizedBox(height: 8),

            // ── MIDDLE: Title & Subtitle ──────────────────────────────────
            if (title.isNotEmpty)
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (objective.isNotEmpty) ...[
              Text(
                objective,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 12),

            // ── BOTTOM: Metric Value + Suffix ─────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      letterSpacing: -1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (suffix.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      suffix,
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),

            // ── Optional Trend Indicator ──────────────────────────────────
            if (hasPositiveTrend || hasNegativeTrend) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: trendColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      hasPositiveTrend
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 14,
                      color: trendColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    hasPositiveTrend ? 'Trending up' : 'Trending down',
                    style: textTheme.labelMedium?.copyWith(
                      color: trendColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ],

          ],
        ),
      );
    } catch (e) {
      return const SafeErrorWidget(message: 'Card failed');
    }
  }
}
