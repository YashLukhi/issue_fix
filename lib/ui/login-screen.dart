import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quize_task_app/ui/registration-screen.dart';
import '../helper/datahelper.dart';
import 'intrest-screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final DBHelper db = DBHelper();

  Future<void> login() async {
    var user = await db.loginUser(
      _mailController.text.trim(),
      _passwordController.text.trim(),
    );

    print("Trying login with: ${_mailController.text} / ${_passwordController.text}");
    print("Result: $user");

    if (user != null) {
      Get.off(() => InterestScreen(user: user));
    } else {
      Get.snackbar(
        "Login Failed",
        "Invalid credentials",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Screen")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _mailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "*Required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Enter User Name",
                  labelText: "UserName",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),

              TextFormField(
                controller: _passwordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "*Required";
                  } else if (value.length != 8) {
                    return 'Password must be 8 char';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Enter Password",
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() =>  RegistrationScreen());
                    },
                    child: const Text("New User ?"),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    login();
                  } else {
                    Get.snackbar(
                      "Error",
                      "Data Error",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                child: const Text("LogIn", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

