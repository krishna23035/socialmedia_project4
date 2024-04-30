import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../login/widger/button.dart';
import '../../login/widger/text_field.dart';
import '../../navigation_bar.dart';
import 'OTP_screen.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  void displayMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: const Duration(seconds: 5), content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter, // Start from bottom
            end: Alignment.topCenter, // End at top
            colors: [Colors.green, Colors.yellow],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/encryption-icon-11.png',
                width: 250,
              ),
              const SizedBox(height: 50),
              const Text(
                'use +91  as prefix  for india',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 10.0),
              MyTextField(
                controller: _phoneNumberController,
                hintText: 'enter your phone number',
                obscureText: false,
                type: TextInputType.phone,
              ),
              const SizedBox(height: 10.0),
              MyButton(
                  function: () {
                    String phoneNumber = _phoneNumberController.text.trim();
                    if (phoneNumber.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OTPScreen(phoneNumber: phoneNumber)),
                      );
                    } else {
                      displayMessage('Please enter a phone number');
                    }
                  },
                  text: 'Send OTP'),
            ],
          ),
        ),
      ),
    );
  }
}
