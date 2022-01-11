import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/theme/colors.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
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
                                  onPressed: () {},
                                  child: const Text('Zaboravili ste lozinku?'),
                                ),
                                SizedBox(
                                  width: 10.h,
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Row(
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
