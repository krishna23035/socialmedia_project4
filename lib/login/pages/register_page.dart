import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widger/button.dart';
import '../widger/text_field.dart';

class RegisteredPage extends StatefulWidget {
  final Function()? onTap;

  const RegisteredPage({super.key, required this.onTap});

  @override
  State<RegisteredPage> createState() => _RegisteredPageState();
}

class _RegisteredPageState extends State<RegisteredPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  bool _isLoading = false;

  void signUp() async {
    setState(() {
      _isLoading = true;
    });

    if (_passwordController.text != _passwordConfirmController.text) {
      displayMessage('Passwords do not match');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );

      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'username': _usernameController.text.split('@')[0],
        'bio': 'Empty bio .. ',
        'contact': 0,
        'profile_img': null
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        displayMessage('The email address is badly formatted');
      } else {
        displayMessage(e.message ?? 'An error occurred');
      }
    } catch (e) {
      displayMessage('An unexpected error occurred');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void displayMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Adjust duration as needed
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          // Handle tap here
          _showTapSplash(context, details.localPosition);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.green, Colors.yellow],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/87390.png',
                      width: 250,
                    ),
                    const SizedBox(height: 50),
                    Text('Instagram Clone',
                        style: TextStyle(color: Colors.grey.shade100)),
                    const SizedBox(height: 10),
                    MyTextFeild(
                      controller: _usernameController,
                      hintText: 'enter your email',
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    MyTextFeild(
                      controller: _passwordController,
                      hintText: 'enter your password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    MyTextFeild(
                      controller: _passwordConfirmController,
                      hintText: 'Re-enter your password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : MyButton(text: 'SignUp', function: signUp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already a Member?',
                            style: TextStyle(color: Colors.grey.shade300)),
                        TextButton(
                          onPressed: widget.onTap,
                          child: Text('Login Now',
                              style: TextStyle(color: Colors.blue.shade500)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showTapSplash(BuildContext context, Offset tapPosition) {
    final overlay = Overlay.of(context)?.context;
    if (overlay != null) {
      final splash = Positioned(
        left: tapPosition.dx - 25,
        top: tapPosition.dy - 25,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.3),
          ),
        ),
      );
      OverlayEntry entry = OverlayEntry(builder: (context) => splash);
      Overlay.of(context).insert(entry);
      Future.delayed(const Duration(milliseconds: 200), () {
        entry.remove();
      });
    }
  }
}