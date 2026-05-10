import 'package:flutter/material.dart';
import 'package:InsightHub/feature/home_and_explore/model/dashboard_item.dart';
import 'package:InsightHub/feature/home_and_explore/widget/base_container.dart';
import 'package:InsightHub/feature/home_and_explore/widget/widget_factory.dart';

class DashboardItemCard extends StatelessWidget {
  final DashboardItem item;
  final bool isCompact;

  const DashboardItemCard({
    super.key,
    required this.item,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final mergedData = item.data is Map
        ? {
            ...item.data as Map<String, dynamic>,
            'title': item.title,
            'objective': item.objective,
          }
        : item.data;

    return BaseContainer(
      title: isCompact ? '' : item.title,
      objective: isCompact ? '' : item.objective,
      description: item.description,
      isCompact: isCompact,
      child: WidgetFactory.build(item.type, mergedData),
    );
  }
}
