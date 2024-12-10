import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:task1/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  final currentUserData = FirebaseAuth.instance.currentUser;
  UserModel? _userModel;

  Map<String, dynamic> currentUser = {
    'name': '',
    'email': '',
    'phone': '',
    'address': '',
    'imageUrl':
        'https://c8.alamy.com/comp/2J3B2T7/3d-illustration-of-smiling-businessman-close-up-portrait-cute-cartoon-man-avatar-character-face-isolated-on-white-background-2J3B2T7.jpg',
  };

  Future<void> fetchUserData() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String? data = s.getString("user_model");

    if (data != null && data.isNotEmpty) {
      try {
        setState(() {
          _userModel = UserModel.fromMap(jsonDecode(data));
          currentUser['name'] = (_userModel!.fullname) ?? 'No Name';
          currentUser['email'] = _userModel!.email ?? 'No Email';
          currentUser['phone'] = _userModel!.phone ?? 'No Phone';
          currentUser['address'] = _userModel!.address ?? 'No Address';
          currentUser['imageUrl'] =
              'https://c8.alamy.com/comp/2J3B2T7/3d-illustration-of-smiling-businessman-close-up-portrait-cute-cartoon-man-avatar-character-face-isolated-on-white-background-2J3B2T7.jpg';
        });
      } catch (e) {
        // Handle JSON decoding error
        debugPrint("Error decoding user data: $e");
      }
    } else {
      debugPrint("No user data found in SharedPreferences.");
      setState(() {
        currentUser['name'] = 'No Name';
        currentUser['email'] = 'No Email';
        currentUser['phone'] = 'No Phone';
        currentUser['address'] = 'No Address';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "User Verification System",
          style: TextStyle(
            color: Color.fromARGB(255, 6, 3, 167),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color.fromARGB(255, 0, 0, 0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 90,
                height: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    'https://c8.alamy.com/comp/2J3B2T7/3d-illustration-of-smiling-businessman-close-up-portrait-cute-cartoon-man-avatar-character-face-isolated-on-white-background-2J3B2T7.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                currentUser['name'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 6, 3, 167),
                ),
              ),
            ),
            SizedBox(height: 40),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Aligns children to the start and end of the row
                children: [
                  Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Text(
                    currentUser['email'],
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 2),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Aligns children to the start and end of the row
                children: [
                  Text(
                    "Address",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Text(
                    currentUser['address'],
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 2),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Aligns children to the start and end of the row
                children: [
                  Text(
                    "Mobile",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Text(
                    currentUser['phone'],
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 2),
          ],
        ),
      ),
    );
  }
}
