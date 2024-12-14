// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mybuddy/auth/auth_functions.dart';
import 'package:mybuddy/consts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final Gemini geminiBot = Gemini.instance;
  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];
  Map<String, dynamic>? userData;
  late ChatUser _currentUser;
  static const String botUserId = 'chat_bot_1';
  final ChatUser _chatBotUser = ChatUser(
      id: botUserId, firstName: 'Chat Bot', profileImage: 'assets/logo.png');
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
              inputOptions: InputOptions(trailing: [
                IconButton(
                    onPressed: () {
                      _chooseImageSource();
                    },
                    icon: const Icon(Icons.image))
              ]),
              messageOptions: const MessageOptions(
                  currentUserContainerColor: Color.fromARGB(255, 104, 171, 182),
                  containerColor: Colors.white,
                  textColor: Colors.black),
              currentUser: _currentUser,
              typingUsers: _typingUsers,
              onSend: _sendMessage,
              messages: _messages,
            ),
    );
  }

  // Function to get response from OpenAI

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      _messages = [chatMessage, ..._messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }
      geminiBot
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen((event) {
        ChatMessage? lastMessage = _messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == _chatBotUser) {
          lastMessage = _messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          lastMessage.text += response;
          setState(
            () {
              _messages = [lastMessage!, ..._messages];
            },
          );
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
              user: _chatBotUser, createdAt: DateTime.now(), text: response);
          setState(() {
            _messages = [message, ..._messages];
          });
        }
      });
    } catch (e) {
      print('the error is ${e}');
    }
  }

  //send media message
  void _chooseImageSource() async {
    // Show a dialog to choose between gallery or camera
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(
                      context, ImageSource.camera); // Return camera source
                },
              ),
              ListTile(
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(
                      context, ImageSource.gallery); // Return gallery source
                },
              ),
            ],
          ),
        );
      },
    );

    // Proceed if the user selected a source
    if (source != null) {
      _pickImage(
          source); // Call function to pick image based on selected source
    }
  }

  void _pickImage(ImageSource source) async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: source);

    if (file != null) {
      // Show a dialog to let the user enter the text
      final userText = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          String inputText = '';
          return AlertDialog(
            title: const Text('Enter your message'),
            content: TextField(
              onChanged: (value) {
                inputText = value;
              },
              decoration: const InputDecoration(
                hintText: 'Describe the image',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null), // Cancel
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, inputText), // Submit
                child: const Text('Send'),
              ),
            ],
          );
        },
      );

      // Proceed only if the user entered some text

      ChatMessage chatMessage = ChatMessage(
        user: _currentUser,
        createdAt: DateTime.now(),
        text: userText ?? "describe the image",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: 'image',
            type: MediaType.image,
          ),
        ],
      );

      // Send the message
      _sendMessage(chatMessage);
    }
  }
}
