enum QuestionType {
  choice,
  scale,
  yesNo;

  static QuestionType fromApi(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'choice') {
      return QuestionType.choice;
    }
    if (normalized == 'yesno' || normalized == 'yes_no') {
      return QuestionType.yesNo;
    }
    return QuestionType.scale;
  }
}

class OptionModel {
  final int id;
  final String text;
  final int numericValue;

  const OptionModel({
    required this.id,
    required this.text,
    required this.numericValue,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: _readInt(json['id']),
      text: (json['text'] ?? '').toString(),
      numericValue: _readInt(json['numericValue'] ?? json['value']),
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse('$value') ?? 0;
  }
}

class QuestionModel {
  final int id;
  final String text;
  final QuestionType type;
  final List<OptionModel> options;
  final int? trackId;

  const QuestionModel({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    this.trackId,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'] as List<dynamic>? ?? const [];
    
    List<OptionModel> options = [];
    for (int i = 0; i < rawOptions.length; i++) {
      final item = rawOptions[i];
      if (item is Map) {
        options.add(OptionModel.fromJson(Map<String, dynamic>.from(item)));
      } else {
        // Fallback for simple string options
        options.add(OptionModel(
          id: i,
          text: item.toString(),
          numericValue: i + 1,
        ));
      }
    }

    return QuestionModel(
      id: _readInt(json['id']),
      text: (json['text'] ?? '').toString(),
      type: QuestionType.fromApi((json['type'] ?? '').toString()),
      options: options,
      trackId: json['trackId'] != null ? _readInt(json['trackId']) : null,
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse('$value') ?? 0;
  }
}
