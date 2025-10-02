import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/datahelper.dart';
import '../model/quiz_opionmodel.dart';

class QuizScreen extends StatelessWidget {
  final Map<String, dynamic> quiz;
  final DBHelper db = DBHelper();

  QuizScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {

    final RxList<QuestionModel> questions = <QuestionModel>[].obs;
    final RxMap<int, int> selectedAnswers = <int, int>{}.obs;
    final RxBool submitted = false.obs;

    final quizData = jsonDecode(quiz['quizData']);
    var qList = (quizData as List)
        .map((q) => QuestionModel.fromJson(q))
        .toList();
    qList.shuffle(Random());
    if (qList.length > 3) {
      qList = qList.sublist(0, 3);
    }
    questions.addAll(qList);

    Future<void> _submitQuiz() async {
      if (selectedAnswers.length < questions.length) {
        Get.snackbar(
          "Error",
          "Please answer all questions!",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      submitted.value = true;
      await db.markQuizCompleted(quiz['id']);
      Get.snackbar(
        "Success",
        "Quiz Submitted!",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(quiz['taskName'])),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final q = questions[index];

                    return Obx(() {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Q${index + 1}: ${q.question}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...q.options.map((opt) {
                                final isSelected =
                                    selectedAnswers[q.questionId] ==
                                    opt.optionId;
                                final isCorrect = opt.isCorrect;
                                Color? tileColor;

                                if (submitted.value) {
                                  if (isSelected && isCorrect) {
                                    tileColor = Colors.green.shade300;
                                  } else if (isSelected && !isCorrect) {
                                    tileColor = Colors.red.shade300;
                                  } else if (!isSelected && isCorrect) {
                                    tileColor = Colors.green.shade100;
                                  } else {
                                    tileColor = null;
                                  }
                                }

                                return Card(
                                  color: tileColor,
                                  child: ListTile(
                                    title: Text(opt.option),
                                    leading: Radio<int>(
                                      value: opt.optionId,
                                      groupValue: selectedAnswers[q.questionId],
                                      onChanged: submitted.value
                                          ? null
                                          : (val) {
                                              selectedAnswers[q.questionId] =
                                                  val!;
                                            },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ),

            Obx(
              () => ElevatedButton(
                onPressed: submitted.value ? null : _submitQuiz,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("submit quiz"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
