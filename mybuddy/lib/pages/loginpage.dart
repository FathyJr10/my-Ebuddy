import 'package:flutter/material.dart';
import 'package:mybuddy/auth/auth_functions.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Center(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                clipBehavior:
                    Clip.hardEdge, // Ensures the child is clipped to the border
                child: Image.asset(
                  'assets/import.gif',
                  width: 100, // Set the width of the image
                  height: 100, // Set the height of the image
                  fit: BoxFit
                      .cover, // Optional: Adjusts the image to fill the box
                ),
              )),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              const SizedBox(
                height: 10,
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
                  if (val == "") {
                    return "please fill this space";
                  }
                  return null;
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
                height: 5,
              ),
              InkWell(
                onTap: () {
                  forgetPass(email.text, context);
                },
                child: Container(
                  alignment: Alignment.topRight,
                  child: const Text(
                    'Forget password ?',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: MaterialButton(
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  color: const Color.fromARGB(255, 104, 171, 182),
                  onPressed: () {
                    if (formState.currentState!.validate()) {
                      print("this is the email ${email.text}");
                      print("this is the password ${password.text}");
                      logIn(context, email.text, password.text);
                    } else {
                      print('error in fields');
                    }
                  },
                  child: const Text(
                    'login',
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
                  Navigator.of(context).pushReplacementNamed("signUp");
                },
                child: const Center(
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: "Don't have an account ? "),
                    TextSpan(
                        text: "Register",
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
      ),
    );
  }
}
