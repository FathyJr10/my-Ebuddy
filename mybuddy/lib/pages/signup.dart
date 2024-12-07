import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybuddy/auth/auth_functions.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool _isObscured = true;
  bool _isConfirmObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(padding: const EdgeInsets.all(15), children: [
        Form(
          key: formState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                'Sign up',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              const Text(
                'Sign up today and take the first step toward unlocking endless possibilities!',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Please fill this space";
                  }
                  // Regular expression to validate email
                  String emailPattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                  RegExp regex = RegExp(emailPattern);
                  if (!regex.hasMatch(val)) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
                controller: email,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Email address',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.only(left: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "please fill this space";
                  }
                },
                controller: password,
                obscureText: _isObscured, // Toggles password visibility
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: 'password',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.only(left: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured =
                              !_isObscured; // Toggle password visibility
                        });
                      },
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Please fill this space";
                  }
                  if (val != password.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
                controller: confirmPassword,
                obscureText: _isConfirmObscured, // Toggles password visibility
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Confirm Password',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.only(left: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmObscured
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmObscured =
                            !_isConfirmObscured; // Toggle visibility
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              Center(
                child: MaterialButton(
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  color: const Color.fromARGB(255, 104, 171, 182),
                  onPressed: () {
                    if (formState.currentState!.validate()) {
                      signUp(email.text, password.text, context);

                      // print("this is the username field: ${username.text}");
                      // print("this is the email field: ${email.text}");
                      // print("this is the password field: ${password.text}");
                    } else {
                      print('error in fields');
                    }
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed("Login");
                },
                child: const Center(
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: "Already have an account "),
                    TextSpan(
                        text: "Log in",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline))
                  ])),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
