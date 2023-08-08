import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  UserModel(
      {required this.uid,
      required this.email,
      required this.fullName});

  String uid;
  String email;
  String fullName;

  factory UserModel.fromFirebase(User user) {
    return UserModel(uid: user.uid, email: user.email!, fullName: user.displayName!);
  }
}
