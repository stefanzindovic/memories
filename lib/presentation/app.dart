import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/providers/current_user_provider.dart';
import 'package:memories/router/router.dart';
import 'package:memories/theme/theme.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: () => ChangeNotifierProvider(
        create: (context) => CurrentUserProvider(),
        child: Consumer<CurrentUserProvider>(builder: (context, auth, __) {
          if (auth.currentUser == null) {
            return MaterialApp(
              theme: generateTheme(),
              debugShowCheckedModeBanner: false,
              initialRoute: '/sign-in',
              onGenerateRoute: generateApplicationRouter,
            );
          } else {
            return MaterialApp(
              theme: generateTheme(),
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              onGenerateRoute: generateApplicationRouter,
            );
          }
        }),
      ),
    );
  }
}
