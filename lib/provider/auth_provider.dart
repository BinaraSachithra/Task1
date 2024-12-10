import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:task1/models/userModel.dart';
import 'package:task1/screen/login.dart';
import 'package:task1/screen/info.dart';
import 'package:task1/screen/register.dart';

class CustomAuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CustomAuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  Future<void> signUpWithEmail(
      BuildContext context, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      _uid = userCredential.user!.uid;

      // Proceed to save user data in Firestore if needed
      Navigator.pushNamed(context, '/login');
      _isLoading = false;
      notifyListeners();
      await toastification.show(
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        context: context,
        title: Text('Sign Up successful. Please login to your account'),
        autoCloseDuration: const Duration(seconds: 4),
      );
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();

      toastification.show(
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        context: context,
        title: Text('Sign-Up failed'),
        description: Text('Email already in use'),
        autoCloseDuration: const Duration(seconds: 4),
      );
    }
  }

// Sign in with Email and Password
  Future<void> signInWithEmail(
      BuildContext context, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      _uid = userCredential.user!.uid;

      // Proceed to check existing user and navigation logic
      checkExistingUser().then((value) {
        if (value == true) {
          // User exists
          Navigator.pushNamed(context, '/register');
        } else {
          // New user
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => Register(
                        email: email,
                      )),
              (route) => false);
        }
      });

      _isLoading = false;
      await toastification.show(
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        context: context,
        title: Text('Sign In successful'),
        autoCloseDuration: const Duration(seconds: 4),
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();

      toastification.show(
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        context: context,
        title: Text('Sign-In failed: $e'),
        autoCloseDuration: const Duration(seconds: 4),
      );
    }
  }

  //Database Operations
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('users').doc(_uid).get();
    if (snapshot.exists) {
      setSignIn();
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      _userModel = UserModel.fromMap(userData);
      SharedPreferences s = await SharedPreferences.getInstance();
      await s.setString("user_model", jsonEncode(userModel.toMap()));

      return true;
    } else {
      print('New User');
      return false;
    }
  }

  void saveUserDataToFIrebase({
    required BuildContext context,
    required UserModel userModel,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      userModel.createdAt = DateTime.now().microsecondsSinceEpoch.toString();
      userModel.uid = _firebaseAuth.currentUser!.uid;
      _userModel = userModel;
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {}
  }

  //shared preference
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? "";
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }

  Future clearUserDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.remove("user_model");
  }
}
