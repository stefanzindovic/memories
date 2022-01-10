import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationModel {
  String? uid;
  String? email;

  AuthenticationModel({
    this.uid,
    this.email,
  });
}
