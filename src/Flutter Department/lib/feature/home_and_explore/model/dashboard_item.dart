class DashboardItem {
  final String id;
  final String type;
  final String title;
  final String objective;
  final String description;
  final dynamic data;

  const DashboardItem({
    required this.id,
    required this.type,
    required this.title,
    required this.objective,
    required this.description,
    required this.data,
  });

  /// 🔥 Factory (Crash-proof + Clean)
  factory DashboardItem.fromJson(Map<String, dynamic>? json) {
    try {
      if (json == null || json.isEmpty) {
        return DashboardItem.fallback();
      }

      final rawType = json['type']?.toString() ?? '';

      return DashboardItem(
        id: json['id']?.toString() ?? '',
        type: _normalizeType(rawType),
        title: json['title']?.toString() ?? 'Untitled',
        objective: json['objective']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        data: json['data'],
      );
    } catch (_) {
      return DashboardItem.fallback();
    }
  }

  /// 🔁 Normalize backend types
  static String _normalizeType(String type) {
    switch (type.toLowerCase().trim()) {
      case "card":
        return "cards";
      case "grouped bar":
        return "multiple bar";
      default:
        return type.toLowerCase().trim();
    }
  }

  /// 🔴 fallback object (no crash)
  factory DashboardItem.fallback() {
    return const DashboardItem(
      id: 'invalid',
      type: 'unknown',
      title: 'Invalid Item',
      objective: '',
      description: '',
      data: [],
    );
  }

  /// 💀 Dummy object for skeletonizer
  factory DashboardItem.dummyCard() {
    return const DashboardItem(
      id: 'dummy_card',
      type: 'cards',
      title: 'Loading Data',
      objective: '',
      description: '',
      data: 0.0,
    );
  }

  factory DashboardItem.dummyChart() {
    return const DashboardItem(
      id: 'dummy_chart',
      type: 'bar',
      title: 'Loading Chart',
      objective: 'Please wait...',
      description: 'Fetching the latest data for your dashboard.',
      data: [],
    );
  }

  /// 🧠 Helper
  bool get isValid => type != 'unknown';
}