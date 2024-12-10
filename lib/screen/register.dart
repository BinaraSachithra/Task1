import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:task1/models/userModel.dart';
import 'package:task1/provider/auth_provider.dart';

class Register extends StatefulWidget {
  const Register({
    super.key,
    required String email,
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool hidePassword = true;
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> sendVerificationEmail() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification(); // Sends a verification email
        print("Verification email sent.");
      } else if (user == null) {
        print("No user is signed in.");
      } else {
        print("Email is already verified.");
      }
    } catch (e) {
      print("An error occurred while sending the verification email: $e");
    }
  }

  Future<void> checkEmailVerification() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        await user.reload(); // Refreshes the user data
        if (user.emailVerified) {
          print("Email verified successfully.");
          // Proceed with navigation or other logic
        } else {
          print("Email not verified yet.");
        }
      } else {
        print("No user is signed in.");
      }
    } catch (e) {
      print("An error occurred while checking email verification: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<CustomAuthProvider>(context, listen: true).isLoading;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 60.0, right: 16, left: 16),
                    child: Column(
                      children: [
                        Container(
                            height: 80, child: Image.asset('assets/login.jpg')),
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 6, 3, 167),
                          ),
                        ),
                        Text(
                          'Register with Email',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          controller: fullnameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        IntlPhoneField(
                          controller: mobileController,
                          disableLengthCheck: true,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          initialCountryCode: 'LK',
                          onChanged: (phone) {
                            print(phone.completeNumber);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          obscureText: hidePassword,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              icon: hidePassword
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            ),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          obscureText: hidePassword,
                          controller: cPasswordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              icon: hidePassword
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            ),
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  Color.fromARGB(255, 255, 255, 255),
                              backgroundColor: Color.fromARGB(255, 6, 3, 167),
                            ),
                            onPressed: () {
                              storeData();
                              signUpWithEmail();
                            },
                            child: Text("Register"),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Log in',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 6, 3, 167),
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "OR",
                            style: TextStyle(
                                color: Color.fromARGB(255, 6, 3, 167),
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color.fromARGB(255, 6, 3, 167),
                              backgroundColor:
                                  Color.fromARGB(255, 255, 255, 255),
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: 20,
                                    child: Image.asset('assets/Google.png')),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text("Register with Google"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color.fromARGB(255, 6, 3, 167),
                              backgroundColor:
                                  Color.fromARGB(255, 255, 255, 255),
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: 20,
                                    child: Image.asset('assets/Facebook.png')),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text("Register with Facebook"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 25.0, top: 15),
                            child: Column(
                              children: [
                                AutoSizeText(
                                  maxFontSize: 12,
                                  minFontSize: 8,
                                  "By Signing up for an account you agree to our",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: 'Terms and Condition',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {}),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }

  void signUpWithEmail() async {
    final ap = Provider.of<CustomAuthProvider>(context, listen: false);
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    ap.signUpWithEmail(context, email, password);
    await clearFields();
  }

  clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  void storeData() {
    final ap = Provider.of<CustomAuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      uid: "",
      createdAt: "",
      fullname: fullnameController.text.trim(),
      phone: mobileController.text.trim(),
      address: addressController.text.trim(),
      email: emailController.text.trim(),
    );
    ap.saveUserDataToFIrebase(
        context: context,
        userModel: userModel,
        onSuccess: () {
          ap.saveUserDataToSP().then((value) => ap.setSignIn().then((value) =>
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false)));
        });
  }
}
