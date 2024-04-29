import 'package:flutter/material.dart';

class MyTextFeild extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;

  const MyTextFeild(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        fillColor: Colors.greenAccent,
        hintStyle: TextStyle(
            color: Colors.grey.shade700, fontWeight: FontWeight.normal),
        hintText: hintText,
      ),
    );
  }
}
