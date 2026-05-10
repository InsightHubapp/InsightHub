import 'package:intl/intl.dart';
import 'package:InsightHub/core/utils/safe_parser.dart';

class ChartHelpers {
  ChartHelpers._();

  static final NumberFormat _compactFormatter = NumberFormat.compact();

  static String compactNumber(num value) {
    return _compactFormatter.format(value);
  }

  static String truncateText(
    String text, {
    int maxLength = 15,
    int visibleCharacters = 12,
  }) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, visibleCharacters)}...';
  }

  static String label(
    Map<String, dynamic> data, {
    String key = 'x',
    String defaultValue = '',
  }) {
    return SafeParser.getString(data, key, defaultValue: defaultValue);
  }

  static double value(Map<String, dynamic> data, {String key = 'y'}) {
    return SafeParser.getDouble(data, key);
  }

  static String selectedAwareLabel(
    Map<String, dynamic> data,
    int index,
    int? selectedIndex,
  ) {
    final fullText = label(data);
    return selectedIndex == index ? fullText : truncateText(fullText);
  }

  static int? toggledSelection(int? tappedIndex, int? selectedIndex) {
    if (tappedIndex == null) return selectedIndex;
    return selectedIndex == tappedIndex ? null : tappedIndex;
  }

  static double dynamicChartHeight(
    int itemCount, {
    double itemExtent = 50,
    double minHeight = 300,
    double maxHeight = 600,
  }) {
    return (itemCount * itemExtent).clamp(minHeight, maxHeight);
  }

  static double totalValue(List<Map<String, dynamic>> rawData) {
    final total = rawData.fold<double>(0, (sum, item) => sum + value(item));
    return total == 0 ? 1 : total;
  }

  static double maxValue(List<Map<String, dynamic>> rawData) {
    final max = rawData.fold<double>(0, (currentMax, item) {
      final itemValue = value(item);
      return itemValue > currentMax ? itemValue : currentMax;
    });
    return max == 0 ? 1 : max;
  }
}
