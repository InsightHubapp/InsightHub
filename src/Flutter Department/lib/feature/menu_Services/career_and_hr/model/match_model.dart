import 'package:InsightHub/core/utils/safe_parser.dart';

class AnswerModel {
  final String question;
  final int answer;
  final String answerText;

  const AnswerModel({
    required this.question,
    required this.answer,
    required this.answerText,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      question: SafeParser.getString(json, 'question'),
      answer: SafeParser.getInt(json, 'answer'),
      answerText: SafeParser.getString(json, 'answerText'),
    );
  }
}

class MatchResultModel {
  final String matchedUserName;
  final List<String> jobs;
  final int totalYearsExperience;
  final double similarityScore;
  final List<AnswerModel> employedAnswers;

  const MatchResultModel({
    required this.matchedUserName,
    required this.jobs,
    required this.totalYearsExperience,
    required this.similarityScore,
    required this.employedAnswers,
  });

  factory MatchResultModel.fromJson(Map<String, dynamic> json) {
    final answers = SafeParser.getList(json, 'employedAnswers');
    final jobs = SafeParser.getList(json, 'jobs');

    return MatchResultModel(
      matchedUserName: SafeParser.getString(json, 'matchedUserName'),
      jobs: jobs.map((job) => job.toString()).toList(),
      totalYearsExperience: SafeParser.getInt(json, 'totalYearsExperience'),
      similarityScore: SafeParser.getDouble(json, 'similarityScore'),
      employedAnswers: answers
          .whereType<Map>()
          .map((item) => AnswerModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }
}

