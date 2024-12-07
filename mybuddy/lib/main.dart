import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mybuddy/auth/auth_functions.dart';
import 'package:mybuddy/pages/contSignup.dart';
import 'package:mybuddy/pages/homepage.dart';
import 'package:mybuddy/pages/loginpage.dart';
import 'package:mybuddy/pages/signup.dart';
import 'package:mybuddy/pages/verifyUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    checkAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 233, 241, 234),
          appBarTheme:
              const AppBarTheme(color: Color.fromARGB(255, 104, 171, 182))),
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? const Homepage()
          : const Login(),
      routes: {
        "signUp": (context) => const SignUp(),
        "Login": (context) => const Login(),
        "Homepage": (context) => const Homepage(),
        "contSignUp": (context) => const ContSignUp(),
        "verifyUser": (context) => const EmailVerificationPage()
      },
    );
  }
}
