// ignore_for_file: use_build_context_synchronously

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybuddy/auth/auth_functions.dart';
import 'package:mybuddy/consts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];
  Map<String, dynamic>? userData;
  late ChatUser _currentUser;
  static const String gptUserId = 'chat_gpt_1';
  final ChatUser _gptChatUser = ChatUser(id: gptUserId, firstName: 'ChatGpt');
  // Fetch the user data from Firestore and set _currentUser dynamically
  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;

          // Get the display name from Firebase Auth or fallback to email
          String userName = FirebaseAuth.instance.currentUser!.displayName ??
              FirebaseAuth.instance.currentUser!.email ??
              'User';

          _currentUser = ChatUser(
            id: FirebaseAuth.instance.currentUser!.uid,
            firstName: userName,
          );
        });
      } else {
        // Handle case where the user document does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User data not found.")),
        );
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data on app start
  }

  final _openAI = OpenAI.instance.build(
      token: OpenAI_API_KEY, //Put the token you got from open AI
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
      enableLog: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: userData == null
            ? const Text(
                'Welcome back!',
                style: TextStyle(color: Colors.white),
              )
            : Text(
                'Welcome back, ${userData!['username']}!',
                style: const TextStyle(color: Colors.white),
              ),
        actions: [
          IconButton(
            onPressed: () {
              signOut(context);
            },
            icon: const Icon(Icons.exit_to_app),
            color: Colors.white,
          ),
        ],
      ),
      body: userData == null
          ? const Center(
              child: SizedBox(
              width: 60.0,
              height: 60.0,
              child: CircularProgressIndicator(),
            ))
          : DashChat(
              messageOptions: const MessageOptions(
                  currentUserContainerColor: Color.fromARGB(255, 104, 171, 182),
                  containerColor: Colors.white,
                  textColor: Colors.white),
              currentUser: _currentUser,
              typingUsers: _typingUsers,
              onSend: (ChatMessage message) {
                getChatResponse(message);
              },
              messages: _messages,
            ),
    );
  }

  // Function to get response from OpenAI
  Future<void> getChatResponse(ChatMessage message) async {
    print("User message: ${message.text}");

    // Add user message to the list and show typing indicator
    setState(() {
      _messages.insert(0, message);
      _typingUsers.add(_gptChatUser);
    });

    // Build chat history
    final _messagesHistory = _messages.reversed.map((m) {
      return {
        "role": m.user == _currentUser ? "user" : "assistant",
        "content": m.text,
      };
    }).toList();

    final request = ChatCompleteText(
      model: GptTurboChatModel(), // Specify the model
      messages: _messagesHistory,
      maxToken: 200,
    );

    try {
      // Fetch response
      final response = await _openAI.onChatCompletion(request: request);

      if (response?.choices.isNotEmpty ?? false) {
        for (var element in response!.choices) {
          if (element.message != null) {
            setState(() {
              _messages.insert(
                0,
                ChatMessage(
                  user: _gptChatUser,
                  createdAt: DateTime.now(),
                  text: element.message!.content,
                ),
              );
            });
          }
        }
      } else {
        print("No response received.");
      }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch response: $e")),
      );
    } finally {
      // Remove typing indicator
      setState(() {
        _typingUsers.remove(_gptChatUser);
      });
    }
  }
}
