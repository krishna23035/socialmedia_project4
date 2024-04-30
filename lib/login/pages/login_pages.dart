import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:socialmedia_project4/login/pages/showOtpDialog.dart';
import '../../AUTH/google_sign_in/signin.dart';
import '../../AUTH/phone_login/login_with_phone.dart';
import '../widger/button.dart';
import '../widger/custom_button.dart';
import '../widger/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _usernameController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      displayMessage(e.code);
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

  // Future<void> phoneSignIn(
  //   BuildContext context,
  //   String phoneNumber,
  // ) async {
  //   TextEditingController codeController = TextEditingController();
  //   await _auth.verifyPhoneNumber(
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await _auth.signInWithCredential(credential);
  //       },
  //       verificationFailed: (e) {
  //         print(e);
  //       },
  //       codeSent: (String verificationId, int? resendToken) async {
  //         showOTPDialog(
  //             codeController: codeController,
  //             context: context,
  //             onPressed: () async {
  //               PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //                 verificationId: verificationId,
  //                 smsCode: codeController.text.trim(),
  //               );
  //
  //               await _auth.signInWithCredential(credential);
  //               Navigator.pop(context);
  //             });
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {});
  // }

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
              begin: Alignment.bottomCenter, // Start from bottom
              end: Alignment.topCenter, // End at top
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
                    const Text('Login Here',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontStyle: FontStyle.italic)),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _usernameController,
                      hintText: 'enter your email',
                      obscureText: false,
                      type: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _passwordController,
                      hintText: 'enter your password',
                      obscureText: true,
                      type: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : MyButton(text: 'Login', function: signIn),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Not a Member?',
                            style: TextStyle(color: Colors.grey.shade300)),
                        TextButton(
                          onPressed: widget.onTap,
                          child: Text('Register Now',
                              style: TextStyle(color: Colors.blue.shade500)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PhoneScreen(),
                          ),
                        );
                      },
                      child: const Text('login with phone number'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SignInButton(
                          Buttons.google,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => GoogleLogin()),
                            );
                          },
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

  void handleGoogleSignIn() {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }

  void _showTapSplash(BuildContext context, Offset tapPosition) {
    final overlay = Overlay.of(context).context;
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
