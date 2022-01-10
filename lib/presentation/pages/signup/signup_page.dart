import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/theme/colors.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

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
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Align(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        const Text('Registrujte se'),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        const Icon(
                                          FeatherIcons.arrowRight,
                                        ),
                                      ],
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
                        onPressed: () {},
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
