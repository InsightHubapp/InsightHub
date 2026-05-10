class HrCorrectAnswerModel {
  final String question;
  final String correctAnswer;
  final String userAnswer;
  final String explanation;
  final String difficulty;
  final bool isCorrect;

  const HrCorrectAnswerModel({
    required this.question,
    required this.correctAnswer,
    required this.userAnswer,
    required this.explanation,
    required this.difficulty,
    required this.isCorrect,
  });

  factory HrCorrectAnswerModel.fromJson(Map<String, dynamic> json) {
    return HrCorrectAnswerModel(
      question: (json['question'] ?? '').toString(),
      correctAnswer: (json['correctAnswer'] ?? '').toString(),
      userAnswer: (json['userAnswer'] ?? '').toString(),
      explanation: (json['explanation'] ?? '').toString(),
      difficulty: (json['difficulty'] ?? '').toString(),
      isCorrect: json['isCorrect'] ?? false,
    );
  }
}

class HrQuizResultModel {
  final int result;
  final List<HrCorrectAnswerModel> correctAnswers;

  const HrQuizResultModel({
    required this.result,
    required this.correctAnswers,
  });

  factory HrQuizResultModel.fromJson(Map<String, dynamic> json) {
    final rawAnswers = json['correctAnswers'] as List<dynamic>? ?? const [];

    return HrQuizResultModel(
      result: _readInt(json['result']),
      correctAnswers: rawAnswers
          .whereType<Map>()
          .map(
            (item) => HrCorrectAnswerModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }
}

int _readInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse('$value') ?? 0;
}
