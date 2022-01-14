import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/models/user.dart';
import 'package:memories/repository/user_informations.dart';
import 'package:memories/theme/colors.dart';

enum SaveUserInfoStatus {
  initial,
  success,
  error,
  loading,
}

class MoreInfoPage extends StatefulWidget {
  const MoreInfoPage({Key? key}) : super(key: key);

  @override
  _MoreInfoPageState createState() => _MoreInfoPageState();
}

class _MoreInfoPageState extends State<MoreInfoPage> {
  final _formKey = GlobalKey<FormState>();
  String _profilePhoto = '';
  String? _name;
  String? errorMessage;
  SaveUserInfoStatus saveUserInfoStatus = SaveUserInfoStatus.initial;

  Future<SaveUserInfoStatus> _saveUserInfo() async {
    SaveUserInfoStatus status = saveUserInfoStatus;
    final UserModel user =
        UserModel(uid: 'test1', name: 'Stefan Zindović', profilePhotoUrl: null);

    try {
      await UserInformations.insertUserInfo(user);
      print('Sve je u redu!');
      status = SaveUserInfoStatus.success;
    } catch (e) {
      print(e);
      status = SaveUserInfoStatus.error;
      errorMessage =
          'Došlo je do neočekivane greške pri čuvanju vaših ličnih podataka. Molimo vas da pokušate ponovo.';
    }

    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(20.w, 0.h, 20.h, 0.h),
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
                  'Hajde da se malo bolje upoznamo.',
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              FeatherIcons.image,
                              color: lightColor,
                            ),
                            SizedBox(
                              width: 10.h,
                            ),
                            const Text('Fotografija iz galerije'),
                          ],
                        ),
                        value: 'pick-from-gallery',
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              FeatherIcons.camera,
                              color: lightColor,
                            ),
                            SizedBox(
                              width: 10.h,
                            ),
                            const Text('Fotografija sa kamere'),
                          ],
                        ),
                        value: 'pick-from-camera',
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              FeatherIcons.trash2,
                              color: lightColor,
                            ),
                            SizedBox(
                              width: 10.h,
                            ),
                            const Text('Uklonite profinu fotografiju'),
                          ],
                        ),
                        value: 'remove-profile-photo',
                        onTap: () {},
                      ),
                    ],
                    child: Container(
                      width: 120.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.r),
                        color: backgroundColor,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          FeatherIcons.user,
                          size: 50.w,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ime i prezime'),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'npr. Marko Marković',
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
                    Align(
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() =>
                              saveUserInfoStatus = SaveUserInfoStatus.loading);
                          SaveUserInfoStatus result = await _saveUserInfo();
                          if (result == SaveUserInfoStatus.success) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);
                          } else if (result == SaveUserInfoStatus.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: backgroundColor,
                                content: Text(
                                  errorMessage.toString(),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                            );
                          }
                          setState(() =>
                              saveUserInfoStatus = SaveUserInfoStatus.initial);
                        },
                        child:
                            (saveUserInfoStatus == SaveUserInfoStatus.loading)
                                ? SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: const CircularProgressIndicator(
                                        color: lightColor),
                                  )
                                : Row(
                                    children: [
                                      const Text('Sačuvajte'),
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
