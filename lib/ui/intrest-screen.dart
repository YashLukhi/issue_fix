import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home-screen.dart';

class InterestScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const InterestScreen({super.key, required this.user});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  final List<String> topics = [
    "Algorithms",
    "Data Structures",
    "Web Development",
    "Testing",
    "Android Development",
    "iOS Development",
    "Kotlin",
    "Swift",
    "MySQL",
    "Firebase",
  ];

  final List<String> selectedTopics = [];

  void toggleSelection(String topic) {
    setState(() {
      if (selectedTopics.contains(topic)) {
        selectedTopics.remove(topic);
      } else {
        if (selectedTopics.length < 10) {
          selectedTopics.add(topic);
        } else {
          Get.snackbar(
            "Limit Reached",
            "You can select up to 10 topics only",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    });
  }

  void next() {
    Get.snackbar(
      "Done",
      "You selected ${selectedTopics.length} topic(s)",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Your Interests",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              "You may select up to 10 topics",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: topics.map((topic) {
                  final isSelected = selectedTopics.contains(topic);
                  return ChoiceChip(
                    label: Text(topic),
                    selected: isSelected,
                    selectedColor: Colors.orange,
                    onSelected: (_) => toggleSelection(topic),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: () async {
                await Get.off(() => HomeScreen(user: widget.user));
              },
              child: const Text(
                "NEXT",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
