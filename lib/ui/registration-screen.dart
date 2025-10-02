import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/datahelper.dart';
import 'login-screen.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conFirmPassController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController conFirmMailController = TextEditingController();

  final DBHelper db = DBHelper();

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      var user = {
        "name": userNameController.text,
        "phone": phoneNumberController.text,
        "email": conFirmMailController.text,
        "password": conFirmPassController.text,
      };

      int res = await db.registerUser(user);

      if (res == -1) {
        Get.snackbar(
          "Error",
          "User already exists",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        var allUsers = await db.getAllUsers();
        print(" All users in Database ");
        for (var u in allUsers) {
          print(
            "ID: ${u['id']}, Name: ${u['name']}, Phone: ${u['phone']}, Email: ${u['email']}, Pass: ${u['password']}",
          );
        }

        Get.snackbar(
          "Success",
          "Registered Successfully",
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.off(() => LoginScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: userNameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "*required";
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
                controller: phoneNumberController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "*required";
                  } else if (value.length < 10) {
                    return "Enter full number";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Enter PhoneNumber",
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),

              TextFormField(
                controller: passwordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Enter Password",
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "*Required";
                  } else if (value.length != 8) {
                    return 'Password must be 8 char';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),

              TextFormField(
                controller: conFirmPassController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: "Enter Confirm Password",
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "*Required";
                  } else if (value.length != 8) {
                    return 'Password must be 8 char';
                  } else if (value != passwordController.text) {
                    return 'Password not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),

              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: mailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Empty";
                  } else if (!value.isValidEmail(value)) {
                    return 'Not Valid Email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Enter E-mail ID",
                  labelText: "Mail ID",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),

              TextFormField(
                controller: conFirmMailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "*Required";
                  } else if (!value.isValidEmail(value)) {
                    return 'Not valid MailID';
                  } else if (value != mailController.text) {
                    return 'MailId not match';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Enter Confirm E-mail ID",
                  labelText: "Confirm Mail ID",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    register();
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on String? {
  bool isValidEmail(String input) {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(input);
  }
}
