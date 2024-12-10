import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task1/provider/auth_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool hidePassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 16, left: 16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Image.asset('assets/login.jpg'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'User Verification System',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 6, 3, 167),
                    ),
                  ),
                  SizedBox(height: 20),
                  const Text(
                    'Continue with Email & Password',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 158, 158, 158),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Email field
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Password field
                  TextFormField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        signInWithEmail();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(
                            255, 6, 3, 167), // Button background color
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white, // Text color
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            color: Color.fromARGB(255, 6, 3, 167),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/register');
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> signInWithEmail() async {
    final ap = Provider.of<CustomAuthProvider>(context, listen: false);
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    ap.signInWithEmail(context, email, password);
    await clearFields();
  }

  clearFields() {
    emailController.clear();
    passwordController.clear();
    Navigator.pushNamed(context, '/info');
  }
}
