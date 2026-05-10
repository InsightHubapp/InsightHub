import 'package:InsightHub/core/utils/safe_parser.dart';

class NavigationStatus {
  final bool isEmployed;
  final bool hasCompletedAssessment;

  const NavigationStatus({
    required this.isEmployed,
    required this.hasCompletedAssessment,
  });

factory NavigationStatus.fromJson(Map<String, dynamic> json) {
  return NavigationStatus(
    isEmployed: SafeParser.getBool(json, 'isEmployed'),
    hasCompletedAssessment: SafeParser.getBool(json, 'hasCompletedAssessment'),
  );
}

}