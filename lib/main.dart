import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memories/presentation/app.dart';
import 'package:memories/providers/collection_data_proivder.dart';
import 'package:memories/providers/connectivity_provider.dart';
import 'package:memories/providers/current_user_provider.dart';
import 'package:memories/providers/memory_data_provider.dart';
import 'package:memories/providers/user_data_provider.dart';
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
          ChangeNotifierProvider(
            create: (_) => UserDataProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => CollectionDataProvoder(),
          ),
          ChangeNotifierProvider(
            create: (_) => MemoryDataProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ConnectivityProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
