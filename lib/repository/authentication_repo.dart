import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:memories/models/authenticationModel.dart';

abstract class AuthenticationRepositoryBase {
  StreamSubscription<User?> get user;
  Future<String> createUser({required String email, required String password});
  Future<String> loginUser({required String email, required String password});
  Future<String> logoutUser({required String email, required String password});
}

class AuthenticationRepository extends AuthenticationRepositoryBase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<String> createUser({required String email, required String password}) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<String> loginUser({required String email, required String password}) {
    // TODO: implement loginUser
    throw UnimplementedError();
  }

  @override
  Future<String> logoutUser({required String email, required String password}) {
    // TODO: implement logoutUser
    throw UnimplementedError();
  }

  @override
  StreamSubscription<User?> get user => _auth.authStateChanges().listen(
      (User? firebaseUser) => (firebaseUser == null) ? null : firebaseUser);
}
