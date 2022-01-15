import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/presentation/widgets/authentication_wrapper.dart';
import 'package:memories/providers/current_user_provider.dart';
import 'package:memories/providers/user_data_provider.dart';
import 'package:memories/router/router.dart';
import 'package:memories/theme/theme.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<CurrentUserProvider>(context, listen: false).setUid();
    Provider.of<CurrentUserProvider>(context, listen: false).setCredentials();
    Provider.of<UserDataProvider>(context, listen: false)
        .setUserData(Provider.of<CurrentUserProvider>(context).uid.toString());
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: () => MaterialApp(
        theme: generateTheme(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: generateApplicationRouter,
        home: const AuthenticationWrapper(),
      ),
    );
  }
}
