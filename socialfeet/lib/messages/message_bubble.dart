import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? const Color.fromARGB(255, 124, 148, 247)
            : const Color.fromARGB(255, 160, 160, 160),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black, // Border color
          width: 1.0, // Border width
        ),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
