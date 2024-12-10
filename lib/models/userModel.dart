import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String fullname;
  String email;
  String phone;
  String address;
  String uid;
  String createdAt;

  UserModel({
    required this.phone,
    required this.uid,
    required this.createdAt,
    required this.fullname,
    required this.email,
    required this.address,
  });

//from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      phone: map['phone'] ?? '',
      uid: map['uid'] ?? '',
      createdAt: map['createdAt'] ?? '',
      fullname: map['fullname'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
    );
  }

  //to map
  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname,
      'email': email,
      'phone': phone,
      'createdAt': createdAt,
      'uid': uid,
      'address': address,
    };
  }
}
