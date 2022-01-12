import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memories/theme/colors.dart';
import 'package:memories/utils/secure_storage.dart';
import 'package:memories/utils/user_authentication.dart';

enum SigninStatus {
  initial,
  loading,
  success,
  error,
}

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String? errorMessage;
  SigninStatus signinStatus = SigninStatus.initial;

  Future<SigninStatus> _loginUser(
      {required String email, required String password}) async {
    SigninStatus status = signinStatus;
    try {
      SecureStorage.deleteUserCredentialFromStorage();
      await UserAuthentication.signinUser(email, password);
      print('Sve je u redu!');
      status = SigninStatus.success;
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found') {
        errorMessage =
            'Korisnik sa tom e-mail adresom ne postoji. Molimo vas da pokušate sa drugom e-mail adresom ili da kreirate novi korisniški račun.';
      } else if (e.code == 'wrong-password') {
        errorMessage =
            'Navedeni podaci za prijavljivanje se ne poklapaju. Molimo vas da pokušate ponovo.';
      } else if (e.code == 'network-request-failed') {
        errorMessage =
            'Internet konekcija nije ostvarena. Molimo vas da provjerite vašu internet vezu i pokušajte ponovo.';
      }
      status = SigninStatus.error;
    } catch (e) {
      print(e);
      errorMessage =
          'Došlo je do neočekivane greške pri prijavljivanju na vaš korisnički račun. Molimo vas da pokušate ponovo malo kasnije.';
      status = SigninStatus.error;
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
                maxHeight: MediaQuery.of(context).size.height - 50.h,
              ),
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
                          'Dobro došli nazad!',
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
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/reset-password');
                                  },
                                  child: const Text('Zaboravili ste lozinku?'),
                                ),
                                SizedBox(
                                  width: 10.h,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(150.w, 65.h),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() =>
                                          signinStatus = SigninStatus.loading);
                                      SigninStatus result = await _loginUser(
                                          email: _email, password: _password);
                                      if (result == SigninStatus.error) {
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
                                          ),
                                        );
                                      } else if (result ==
                                          SigninStatus.success) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, '/', (route) => false);
                                      }
                                      setState(() =>
                                          signinStatus = SigninStatus.initial);
                                    }
                                  },
                                  child: (signinStatus == SigninStatus.loading)
                                      ? SizedBox(
                                          width: 24.w,
                                          height: 24.h,
                                          child:
                                              const CircularProgressIndicator(
                                                  color: lightColor),
                                        )
                                      : Row(
                                          children: [
                                            const Text('Prijavite se'),
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
                              height: 20.h,
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
                        'Nemate korisnički račun?',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 12.sp),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign-up');
                        },
                        child: Text(
                          'Registrujte se!',
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
