import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quize_task_app/ui/quiz-screen.dart';

import '../helper/datahelper.dart';
import '../model/quizjson.dart';
import 'login-screen.dart';


class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper db = DBHelper();
  List<Map<String, dynamic>> quizzes = [];

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    final data = await db.getUserQuizzes(widget.user['id']);
    setState(() {
      quizzes = data;
    });
  }

  Future<void> _generateNewQuiz() async {
    final taskName = "Task ${quizzes.length + 1}";
    final quizJson = jsonEncode(rawQuizJson);

    await db.insertQuiz(
      widget.user['id'],
      taskName,
      "Quiz generated for practice.",
      quizJson,
    );

    _loadQuizzes();
  }

  void _logout() {
    Get.off(() => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final taskCount = quizzes.where((q) => q['isCompleted'] == 0).length;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Dashboard"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hello,",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            Text(
              widget.user['name'] ?? "User",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onPressed: _generateNewQuiz,
              icon: const Icon(Icons.add_task),
              label: const Text("Generate New Quiz"),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onPressed: () {},
              icon: const Icon(Icons.notifications),
              label: Text("You have $taskCount task(s) due"),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: quizzes.isEmpty
                  ? const Center(
                child: Text(
                  "Click on Generate New Quiz to create a new task",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.builder(
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes[index];
                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.assignment,
                        color: Colors.blue,
                      ),
                      title: Text(
                        quiz['taskName'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        quiz['description'],
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          if (quiz['isCompleted'] == 1) {
                            Get.snackbar(
                              "Info",
                              "Quiz already completed!",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } else {
                            Get.to(() => QuizScreen(quiz: quiz))
                                ?.then((_) => _loadQuizzes());
                          }
                        },
                        child: const Text("Start"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
