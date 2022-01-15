import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memories/presentation/app.dart';
import 'package:memories/providers/current_user_provider.dart';
import 'package:memories/repository/user_informations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(
    () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CurrentUserProvider>(
            create: (_) => CurrentUserProvider(),
          ),
          Provider(
            create: (_) => UserInformations(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
