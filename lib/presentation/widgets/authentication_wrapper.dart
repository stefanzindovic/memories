import 'package:flutter/material.dart';
import 'package:memories/presentation/pages/home/home_page.dart';
import 'package:memories/presentation/pages/more_info/more_info_page.dart';
import 'package:memories/presentation/pages/signin/signin_page.dart';
import 'package:memories/providers/current_user_provider.dart';
import 'package:memories/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? _uid = Provider.of<CurrentUserProvider>(context).uid;
    if (_uid == null) {
      return const SigninPage();
    } else {
      final _userData = Provider.of<UserDataProvider>(context).userData;
      if (_userData == null) {
        return const MoreInfoPage();
      } else {
        return const HomePage();
      }
    }
  }
}
