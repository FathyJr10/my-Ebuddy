import 'package:flutter/material.dart';
import 'package:mybuddy/auth/auth_functions.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(
              color: Colors
                  .white), // Set text color to contrast with blue background
        ),
        actions: [
          IconButton(
            onPressed: () {
              signOut(context);
            },
            icon: const Icon(Icons.exit_to_app),
            color: Colors
                .white, // Optional: set the icon color to white for contrast
          ),
        ],
      ),
    );
  }
}
