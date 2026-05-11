import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/core/constant/app_shadow.dart';
import 'package:InsightHub/feature/home_and_explore/widget/safe_error_widget.dart';

class BaseContainer extends StatelessWidget {
  final String title;
  final String? objective;
  final String? description;
  final Widget? child;
  final bool isCompact;

  const BaseContainer({
    super.key,
    required this.title,
    this.objective,
    this.description,
    this.child,
    this.isCompact = false,
  });

  Widget _safeChild() {
    try {
      if (child == null) return const SizedBox.shrink();
      return child!;
    } catch (e) {
      return const SafeErrorWidget(
        message: 'Failed to load content.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: AppColors.border,
          width: 1.0,
        ),
        boxShadow: AppShadows.level2,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          isCompact ? 12.0 : 18.0,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title.isNotEmpty)
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: isCompact ? 12 : 16,
                  fontWeight: isCompact ? FontWeight.w600 : FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

            if (objective != null &&
                objective!.isNotEmpty) ...[
              const SizedBox(height: 4.0),

              Text(
                objective!,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
                maxLines: isCompact ? 1 : 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            SizedBox(
              height: isCompact ? 8.0 : 18.0,
            ),

            _safeChild(),

            if (description != null &&
                description!.isNotEmpty) ...[
              SizedBox(
                height: isCompact ? 8.0 : .0,
              ),

              Divider(
                color: colorScheme.outlineVariant,
                height: 1,
              ),

              SizedBox(
                height: isCompact ? 12.0 : 16.0,
              ),

              Container(
                padding: EdgeInsets.all(
                  isCompact ? 10.0 : 12.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.shadowblue.withValues(alpha: 0.24),
                  borderRadius:
                      BorderRadius.circular(8.0),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          size: 16,
                          color: AppColors.primaryBlue,
                        ),

                        const SizedBox(width: 8.0),

                        Flexible(
                          child: Text(
                            'Description',
                            style: textTheme.labelSmall
                                ?.copyWith(
                                  color:
                                     AppColors.primaryBlue,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8.0),

                    Text(
                      description!,
                      style: textTheme.bodySmall
                          ?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant,
                            height: 1.45,
                            fontSize: isCompact ? 11 : 13,
                          ),
                      maxLines:
                          isCompact ? 3 : 5,
                      overflow:
                          TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}