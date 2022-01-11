import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memories/theme/colors.dart';
import 'package:memories/utils/secure_storage.dart';
import 'package:memories/utils/user_authentication.dart';

enum SignupStatus { initial, loading, success, error }

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String? errorMessage;
  SignupStatus signupStatus = SignupStatus.initial;

  Future<SignupStatus> signupUser(
      {required String email, required String password}) async {
    SignupStatus status = signupStatus;
    try {
      await SecureStorage.deleteUserCredentialFromStorage();
      await UserAuthentication.signupUser(email, password);
      status = SignupStatus.success;
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'email-already-in-use') {
        errorMessage =
            'Željena e-mail adresa je već u upotrebi. Molimo vas da pokušate ponovo sa nekom drugom e-mail adresom.';
      }
      status = SignupStatus.error;
    } catch (e) {
      print(e);
      errorMessage =
          'Došlo je do greške pri kreiranju vašeg korisničkog računa. Molimo vas da pokušate ponovo malo kasnije.';
      status = SignupStatus.error;
    }

    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0.h),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 50.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 50.h,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Čuvajte sve uspomene na jednom mjestu!',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text("E-mail adresa"),
                            ),
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
                            SizedBox(
                              height: 20.h,
                            ),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text("Lozinka"),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              style: const TextStyle(color: lightColor),
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'koristite najmanje 8 karaktera...',
                              ),
                              validator: (value) {
                                if (value!.length < 8 || value.length > 24) {
                                  return 'Unešena lozinka nije validna. Molimo vas da unesete lozinku koja je duža od 8 i krća od 24 karaktera.';
                                } else {
                                  setState(() => _password = value);
                                }
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Align(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(170.w, 65.h),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => signupStatus =
                                            SignupStatus.loading);
                                        SignupStatus result = await signupUser(
                                            email: _email, password: _password);
                                        if (result == SignupStatus.success) {
                                          print("Sve je u redu");
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '/more-info',
                                              (route) => false);
                                        } else if (result ==
                                            SignupStatus.error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: backgroundColor,
                                              content: Text(
                                                errorMessage.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      }
                                      setState(() =>
                                          signupStatus = SignupStatus.initial);
                                    },
                                    child:
                                        (signupStatus == SignupStatus.initial)
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text('Registrujte se'),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  const Icon(
                                                    FeatherIcons.arrowRight,
                                                  ),
                                                ],
                                              )
                                            : SizedBox(
                                                width: 24.w,
                                                height: 24.h,
                                                child:
                                                    const CircularProgressIndicator(
                                                        color: lightColor),
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Već imate korisnički raćun?',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 12.sp),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign-in');
                        },
                        child: Text(
                          'Prijavite se!',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
