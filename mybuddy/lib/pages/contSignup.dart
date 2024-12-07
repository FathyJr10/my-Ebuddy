import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybuddy/auth/auth_functions.dart';

class ContSignUp extends StatefulWidget {
  const ContSignUp({super.key});

  @override
  State<ContSignUp> createState() => _ContSignUpState();
}

class _ContSignUpState extends State<ContSignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController age = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  // This function is called when the user submits the form

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            const SizedBox(height: 100),
            const Text(
              'Sign up',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            const SizedBox(height: 15),
            const Text(
              'Please enter your username to continue.',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
            ),
            const SizedBox(height: 25),

            // Form field for the username
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: username,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please enter a username";
                      }
                      String pattern = r'^[a-zA-Z0-9]+$';
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(val)) {
                        return "Username can only contain letters and numbers";
                      }
                      if (val.length < 4) {
                        return "Username must be at least 4 characters long";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'Enter your username',
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: age,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please enter an age";
                      }

                      // Try to parse the value as an integer
                      final age = int.tryParse(val);

                      // Check if the parsed value is null or less than 0
                      if (age == null || age < 0) {
                        return "Please enter a valid age (positive number)";
                      }

                      return null; // Return null if validation is successful
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'Enter your age',
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 30),

                  // Submit Button
                  Center(
                    child: MaterialButton(
                      height: 50,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      color: const Color.fromARGB(255, 104, 171, 182),
                      onPressed: () {
                        if (formState.currentState!.validate()) {
                          signUpCont(
                              username: username.text,
                              age: int.tryParse(age.text) ?? 0,
                              context: context);
                        }
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Navigation to login screen
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
