import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const MyTextField(
      {super.key,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: Color.fromARGB(255, 219, 219, 219), // TextField color
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black), // Hint text color
        ),
      ),
    );
  }
}
