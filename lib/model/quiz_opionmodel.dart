class OptionModel {
  final int optionId;
  final String option;
  final bool isCorrect;
  bool isUserSelected;

  OptionModel({
    required this.optionId,
    required this.option,
    required this.isCorrect,
    this.isUserSelected = false,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      optionId: json["option_id"],
      option: json["option"],
      isCorrect: json["correct_answer"] == 1,
      isUserSelected: json["user_answer"] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "option_id": optionId,
      "option": option,
      "correct_answer": isCorrect ? 1 : 0,
      "user_answer": isUserSelected ? 1 : 0,
    };
  }
}

class QuestionModel {
  final int questionId;
  final String question;
  final int correctAnswerId;
  final List<OptionModel> options;

  QuestionModel({
    required this.questionId,
    required this.question,
    required this.correctAnswerId,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionId: json["question_id"],
      question: json["question"],
      correctAnswerId: json["correct_answer_option_id"],
      options: (json["quiz_options"] as List)
          .map((e) => OptionModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question_id": questionId,
      "question": question,
      "correct_answer_option_id": correctAnswerId,
      "quiz_options": options.map((e) => e.toJson()).toList(),
    };
  }
}
