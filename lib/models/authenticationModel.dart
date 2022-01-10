import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationModel {
  String? uid;
  String? email;

  AuthenticationModel({
    required this.uid,
    required this.email,
  });

  AuthenticationModel.fromFirebaseUser({User? user}) {
    uid = user!.uid;
    email = user.email!;
  }
}
