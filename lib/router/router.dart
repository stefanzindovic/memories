import 'package:flutter/material.dart';
import 'package:memories/presentation/pages/add_collection/add_collection.dart';
import 'package:memories/presentation/pages/add_memory/add_memory_page.dart';
import 'package:memories/presentation/pages/collection/collection_page.dart';
import 'package:memories/presentation/pages/confirm_identity/confirm_identity_page.dart';
import 'package:memories/presentation/pages/edit_collection/edit_collection_page.dart';
import 'package:memories/presentation/pages/edit_memory/edit_memory_page.dart';
import 'package:memories/presentation/pages/edit_user_info/edit_user_info_page.dart';
import 'package:memories/presentation/pages/home/home_page.dart';
import 'package:memories/presentation/pages/memory/memory_page.dart';
import 'package:memories/presentation/pages/more_info/more_info_page.dart';
import 'package:memories/presentation/pages/profile_options/profile_options_page.dart';
import 'package:memories/presentation/pages/reset_password/reset_password_page.dart';
import 'package:memories/presentation/pages/signin/signin_page.dart';
import 'package:memories/presentation/pages/signup/signup_page.dart';
import 'package:memories/router/routes.dart';

Route generateApplicationRouter(RouteSettings settings) {
  switch (settings.name) {
    case homeRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => const HomePage());
    case memoryRoute:
      final arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (BuildContext context) => MemoryPage(
          data: arguments,
        ),
      );
    case collectionRoute:
      final arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (BuildContext context) => CollectionPage(
          data: arguments,
        ),
      );
    case addCollectionRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => const AddCollectionPage());
    case addMemoryRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => const AddMemoryPage());
    case editCollectionRoute:
      final arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (BuildContext context) => EditCollectionPage(
          data: arguments,
        ),
      );
    case editMemoryRoute:
      final arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (BuildContext context) => EditMemoryPage(
          data: arguments,
        ),
      );
    case settingsRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => const ProfileOptionsPage());
    case moreInfoRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => const MoreInfoPage());
    case resetPasswordRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => const ResetPasswordPage());
    case editProfileRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => const EditUserInfoPage());
    case signInRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => const SigninPage());
    case signUpRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => const SignupPage());
    case confirmIdentitiyRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => const ConfirmIdentityPage());
    default:
      return MaterialPageRoute(
          builder: (BuildContext context) => const HomePage());
  }
}
