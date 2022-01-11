import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ResetPasswordStatus {
  initial,
  loading,
  success,
  error,
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String errorMessage = '';
  ResetPasswordStatus resetPasswordStatus = ResetPasswordStatus.initial;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      minimum: EdgeInsets.fromLTRB(20.h, 0.h, 20.h, 0.h),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50.h,
              ),
              Text(
                'Zaboravili ste vašu lozinku?',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Link koji će vam omogućiti da izmijenite vašu lozinku će biti poslat na vašu e-mail adresu.',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 20.h,
              ),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('E-mail adresa'),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'npr. markomarkovic@gmail.com',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Odustanite'),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        const Text('Dalje'),
                        SizedBox(
                          width: 5.w,
                        ),
                        const Icon(
                          FeatherIcons.arrowRight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
