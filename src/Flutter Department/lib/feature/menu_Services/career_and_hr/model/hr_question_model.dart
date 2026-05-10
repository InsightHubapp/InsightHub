enum HrQuestionType {
  multipleChoice,
  trueFalse;

  static HrQuestionType? fromApi(String value) {
    switch (value.trim().toUpperCase()) {
      case 'MULTIPLE_CHOICE':
        return HrQuestionType.multipleChoice;
      case 'TRUE_FALSE':
        return HrQuestionType.trueFalse;
      default:
        return null;
    }
  }
}

class HrAnswerModel {
  final int id;
  final String option;
  final int number;
  final bool isCorrect;

  const HrAnswerModel({
    required this.id,
    required this.option,
    required this.number,
    required this.isCorrect,
  });

  factory HrAnswerModel.fromJson(Map<String, dynamic> json) {
    return HrAnswerModel(
      id: _readInt(json['id']),
      option: (json['option'] ?? '').toString(),
      number: _readInt(json['number']),
      isCorrect: json['isCorrect'] == true,
    );
  }
}

class HrQuestionModel {
  final int id;
  final String question;
  final HrQuestionType type;
  final String? difficulty;
  final String? explanation;
  final List<HrAnswerModel> answers;

  const HrQuestionModel({
    required this.id,
    required this.question,
    required this.type,
    required this.answers,
    this.difficulty,
    this.explanation,
  });

  factory HrQuestionModel.fromJson(Map<String, dynamic> json) {
    final parsedType = HrQuestionType.fromApi((json['type'] ?? '').toString());
    final rawAnswers = json['answers'] as List<dynamic>? ?? const [];

    return HrQuestionModel(
      id: _readInt(json['id']),
      question: (json['question'] ?? '').toString(),
      type: parsedType ?? HrQuestionType.multipleChoice,
      difficulty: json['difficulty']?.toString(),
      explanation: json['explanation']?.toString(),
      answers: rawAnswers
          .whereType<Map>()
          .map((item) => HrAnswerModel.fromJson(Map<String, dynamic>.from(item)))
          .toList()
        ..sort((a, b) => a.number.compareTo(b.number)),
    );
  }

  bool get isSupported =>
      type == HrQuestionType.multipleChoice || type == HrQuestionType.trueFalse;
}

int _readInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse('$value') ?? 0;
}
