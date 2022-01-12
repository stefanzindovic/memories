import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memories/theme/colors.dart';
import 'package:memories/utils/user_authentication.dart';

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

  Future<ResetPasswordStatus> _resetPassword({required String email}) async {
    ResetPasswordStatus status = resetPasswordStatus;

    try {
      await UserAuthentication.sendLinkForResetPassword(email);
      print('Sve je u redu');
      status = ResetPasswordStatus.success;
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found') {
        errorMessage =
            'Korisnik sa tom e-mail adresom ne postoji. Molimo vas da pokušate sa drugom e-mail adresom.';
      } else if (e.code == 'network-request-failed') {
        errorMessage =
            'Internet konekcija nije ostvarena. Molimo vas da provjerite vašu internet vezu i pokušajte ponovo.';
      }
      status = ResetPasswordStatus.error;
    } catch (e) {
      print(e);
      errorMessage =
          'Došlo je do neočekivane greške pri izmjeni vaše lozinke. Molimo vas da pokušate ponovo.';
      status = ResetPasswordStatus.error;
    }

    return status;
  }

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
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('E-mail adresa'),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextFormField(
                      style: GoogleFonts.encodeSans(color: lightColor),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'npr. markomarkovic@gmail.com',
                      ),
                      validator: (value) {
                        if (value!.length < 3 ||
                            value.length > 320 ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          return 'Unešena e-mail adresa je ne validna. Molimo vas da unesete e-mail adresu koja je validna. (ime@domen.com)';
                        } else {
                          setState(() => _email = value);
                        }
                      },
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Odustanite'),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(110.w, 65.h),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() =>
                            resetPasswordStatus = ResetPasswordStatus.loading);
                        ResetPasswordStatus result =
                            await _resetPassword(email: _email);
                        if (result == ResetPasswordStatus.success) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: backgroundColor,
                              content: Text(
                                'Link za izmjenu vaše lozinke je uspjesno poslat na vašu e-mail adresu. Molimo vas da provjerite vašu elektronsku poštu.',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else if (result == ResetPasswordStatus.error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: backgroundColor,
                              content: Text(
                                errorMessage.toString(),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                        setState(() =>
                            resetPasswordStatus = ResetPasswordStatus.initial);
                      }
                    },
                    child: (resetPasswordStatus == ResetPasswordStatus.loading)
                        ? SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: const CircularProgressIndicator(
                                color: lightColor),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
