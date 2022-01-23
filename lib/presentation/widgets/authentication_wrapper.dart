import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/models/user.dart';
import 'package:memories/presentation/pages/home/home_page.dart';
import 'package:memories/presentation/pages/more_info/more_info_page.dart';
import 'package:memories/presentation/pages/signin/signin_page.dart';
import 'package:memories/providers/current_user_provider.dart';
import 'package:memories/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  String? _uid;
  UserModel? _user;
  Widget? _screen;

  @override
  Widget build(BuildContext context) {
    setState(() => _uid = Provider.of<CurrentUserProvider>(context).uid);
    setState(() => _user = Provider.of<UserDataProvider>(context).userData);
    Timer t = Timer(const Duration(milliseconds: 750), () {
      if (_uid == null) {
        setState(() => _screen = const SigninPage());
      } else {
        Timer t = Timer(const Duration(milliseconds: 750), () {
          if (_user == null) {
            setState(() => _screen = const MoreInfoPage());
          } else {
            setState(() => _screen = const HomePage());
          }
        });
      }
    });

    if (_screen == null) {
      return Scaffold(
        body: Center(
          child: SizedBox(
              width: 140.w,
              height: 140.h,
              child: Image.asset('assets/logo.png')),
        ),
      );
    } else {
      return _screen!;
    }
  }
}
