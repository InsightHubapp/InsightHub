import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:InsightHub/feature/home_and_explore/model/dashboard_item.dart';
import 'package:InsightHub/feature/home_and_explore/widget/dashboard_item_card.dart';
import 'package:InsightHub/widget/app_motion.dart';

class DashboardItemsView extends StatelessWidget {
  const DashboardItemsView({
    
    super.key,
    required this.items,
    required this.onRefresh,
    this.emptyMessage = 'No analysis data available right now.',
  });

  final List<DashboardItem> items;
  final Future<void> Function() onRefresh;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyDashboardView(message: emptyMessage, onRefresh: onRefresh);
    }

    final cardItems = items.where((item) => item.type == 'cards').toList();
    final otherItems = items.where((item) => item.type != 'cards').toList();

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;

      },
      child: RefreshIndicator(
        onRefresh: onRefresh,

        child: AppMotion(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              ..._buildCardRows(cardItems),
              ..._buildOtherItems(otherItems),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCardRows(List<DashboardItem> cardItems) {
    return List.generate((cardItems.length / 2).ceil(), (rowIndex) {
      final left = cardItems[rowIndex * 2];
      final rightIndex = rowIndex * 2 + 1;
      final hasRight = rightIndex < cardItems.length;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: DashboardItemCard(item: left, isCompact: true)),
              const SizedBox(width: 12),
              Expanded(
                child: hasRight
                    ? DashboardItemCard(
                        item: cardItems[rightIndex],
                        isCompact: true,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _buildOtherItems(List<DashboardItem> otherItems) {
    return otherItems
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(top: 12),
            child: DashboardItemCard(item: item, isCompact: false),
          ),
        )
        .toList();
  }
}

class _EmptyDashboardView extends StatelessWidget {
  const _EmptyDashboardView({required this.message, required this.onRefresh});

  final String message;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 150),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textGray),
              ),
            ),
          ),
        ],
      ),
    );
  }
}