import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

String userID = FirebaseAuth.instance.currentUser!.uid;
String? email = FirebaseAuth.instance.currentUser!.email;

Future<void> forgetPass(String emailAddress, BuildContext context) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailAddress); //ma3dtsh bt-check elauth khalas
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      //animType: AnimType.,
      title: 'Check ur inbox',
      desc: 'an email is sent to your email if the email exists.',
      btnOkOnPress: () {},
    ).show();
  } catch (e) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Invalid email',
      desc: 'email is badly formatted enter a valid email.',
      btnOkOnPress: () {},
    ).show();
  }
}

Future<void> signUpCont(
    {required String username,
    required int age,
    required BuildContext context}) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Add user details to Firestore
    await users.doc(userID).set({
      'username': username,
      'email': email,
      'age': age,
      'userID': userID,
      'created_at':
          FieldValue.serverTimestamp(), // To track when the user was created
    });
    Navigator.of(context).pushReplacementNamed('verifyUser');

    print('User added to Firestore with ID: $userID');
  } catch (e) {
    print('Error adding user to Firestore: $e');
  }
}

Future<void> signUp(
    dynamic email, dynamic password, BuildContext context) async {
  try {
    // Create a user with email and password
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Access user ID
    String userID =
        userCredential.user?.uid ?? ''; // Get user ID or empty string if null
    print("User ID: $userID");

    // Navigate to the next screen after successful signup
    Navigator.of(context).pushReplacementNamed('contSignUp');
  } on FirebaseAuthException catch (e) {
    print("The error is: ${e.message}");

    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    } else {
      print("Unexpected error: ${e.message}");
    }
  } catch (e) {
    // Handle other types of exceptions
    print("Unexpected error: $e");
  }
}

signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context).pushNamedAndRemoveUntil("Login", (route) => false);
  print(
      '=====================================signedOut========================================');
}

Future<void> logIn(
  BuildContext context,
  String emailAddress,
  String password,
) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
    if (credential.user!.emailVerified) {
      Navigator.of(context).pushReplacementNamed("Homepage");
    } else {
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Imp',
        desc: 'Please Verify Your e-mail',
        btnOkOnPress: () {},
      ).show();
    }
  } on FirebaseAuthException catch (e) {
    print(e.code);

    if (e.code == 'invalid-credential') {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Invalid data for user',
        desc:
            'No user found for that email address or the password entered is wrong.',
        btnOkOnPress: () {},
      ).show();
    }
  } catch (e) {
    print(e);
  }
}

Future<void> checkAuth() async {
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('+++++++++++++++++User is currently signed out!');
    } else {
      print('+++++++++++++++++User is signed in!');
    }
  });
}
