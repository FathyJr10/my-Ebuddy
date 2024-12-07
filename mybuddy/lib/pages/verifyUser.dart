import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool isSending = false;
  Timer? verificationTimer;

  @override
  void initState() {
    super.initState();
    // Start periodic check for email verification
    verificationTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      checkEmailVerified();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    verificationTimer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.reload(); // Refresh user data
      if (user.emailVerified) {
        verificationTimer?.cancel(); // Stop checking once verified
        Navigator.of(context).pushReplacementNamed('Homepage');
      }
    }
  }

  Future<void> sendEmailVerification() async {
    setState(() {
      isSending = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification email sent to ${user.email}.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
        ),
      );
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Email Verification'),
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Press the button below to send a verification email.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isSending ? null : sendEmailVerification,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 104, 171, 182), // Button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  elevation: 15, // Shadow depth
                ),
                child: isSending
                    ? const CircularProgressIndicator(
                        color: Color.fromARGB(255, 104, 171, 182),
                      )
                    : const Text(
                        'Send Verification Email',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Once you verify your email, you will be redirected to the homepage.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
