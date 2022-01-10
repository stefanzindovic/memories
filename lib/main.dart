import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memories/presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() => runApp(const MyApp()));
}
