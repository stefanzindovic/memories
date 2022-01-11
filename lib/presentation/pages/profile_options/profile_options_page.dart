import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/theme/colors.dart';
import 'package:memories/utils/user_authentication.dart';

enum LogoutStatus {
  initial,
  loading,
  success,
  error,
}

class ProfileOptionsPage extends StatefulWidget {
  const ProfileOptionsPage({Key? key}) : super(key: key);

  @override
  _ProfileOptionsPageState createState() => _ProfileOptionsPageState();
}

class _ProfileOptionsPageState extends State<ProfileOptionsPage> {
  LogoutStatus logoutStatus = LogoutStatus.initial;
  String? errorMessage;

  Future<LogoutStatus> logoutUser() async {
    LogoutStatus status = logoutStatus;

    try {
      await UserAuthentication.signoutUser();
      print('Sve je u redu!');
      status = LogoutStatus.success;
    } catch (e) {
      print(e);
      errorMessage =
          'Došlo je do neočekivane greške pri odjavljivanju sa vašeg korisničkog računa. Molimo vas da pokušate ponovo kasnije.';
      status = LogoutStatus.error;
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Podešavanja',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0.h),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/edit-profile');
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 20.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                FeatherIcons.info,
                                color: lightColor,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text('Izmijenite lične informacije'),
                            ],
                          ),
                          const Icon(FeatherIcons.arrowRight),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                GestureDetector(
                  onTap: () async {},
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 20.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                FeatherIcons.lock,
                                color: lightColor,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text('Izmijenite lozinku'),
                            ],
                          ),
                          const Icon(FeatherIcons.arrowRight),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() => logoutStatus = LogoutStatus.loading);
                    LogoutStatus result = await logoutUser();
                    if (result == LogoutStatus.error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: backgroundColor,
                          content: Text(
                            errorMessage.toString(),
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      );
                    } else if (result == LogoutStatus.success) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/sign-in', (route) => false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: backgroundColor,
                          content: Text(
                            'Uspješno ste se odjavili sa vašeg korisničkog računa!',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      );
                    }
                    setState(() => logoutStatus = LogoutStatus.initial);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 20.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                FeatherIcons.logOut,
                                color: lightColor,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text('Odjavite se'),
                            ],
                          ),
                          (logoutStatus == LogoutStatus.loading)
                              ? SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: CircularProgressIndicator(
                                    color: textColor,
                                  ),
                                )
                              : const Icon(FeatherIcons.arrowRight),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.7,
                  height: 2.h,
                  color: lightColor,
                ),
                SizedBox(
                  height: 50.h,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 20.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                FeatherIcons.trash2,
                                color: lightColor,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text('Deaktivirajte korisnički račun'),
                            ],
                          ),
                          const Icon(FeatherIcons.arrowRight),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
