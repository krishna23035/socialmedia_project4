import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../login/widger/button.dart';
import '../../login/widger/text_field.dart';
import '../../navigation_bar.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  String _verificationId = '';

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
              Text(
                'Enter OTP sent to ${widget.phoneNumber}',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10.0),
              MyTextField(
                controller: _otpController,
                hintText: 'enter OTP',
                obscureText: false,
                type: TextInputType.number,
              ),
              const SizedBox(height: 10.0),
              MyButton(
                function: _verifyOTP,
                text: 'Verify OTP',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOTP() async {
    String otp = _otpController.text.trim();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: otp);
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CustomNavigationBar()),
      );
    } catch (e) {
      displayMessage('Error verifying OTP: $e');
    }
  }
}
