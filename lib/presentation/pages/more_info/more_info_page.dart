import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memories/models/user.dart';
import 'package:memories/providers/current_user_provider.dart';
import 'package:memories/repository/user_informations.dart';
import 'package:memories/theme/colors.dart';
import 'package:provider/provider.dart';

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
  String _name = '';
  String? errorMessage;
  SaveUserInfoStatus saveUserInfoStatus = SaveUserInfoStatus.initial;
  File? _profilePhoto;

  Future getImageFromGallery() async {
    ImagePicker _picker = ImagePicker();
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _profilePhoto = File(file.path));
    }
  }

  Future getImageFromCamera() async {
    ImagePicker _picker = ImagePicker();
    XFile? file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      setState(() => _profilePhoto = File(file.path));
    }
  }

  Future<SaveUserInfoStatus> _saveUserInfo() async {
    SaveUserInfoStatus status = saveUserInfoStatus;
    String? _profilePhotoUrl;
    String _uid =
        Provider.of<CurrentUserProvider>(context, listen: false).uid.toString();
    try {
      if (_profilePhoto != null) {
        _profilePhotoUrl =
            await UserInformations.uploadProfilePicture(_uid, _profilePhoto!);
      }
      final UserModel user = UserModel(
        uid: _uid,
        name: _name,
        profilePhotoUrl: _profilePhotoUrl,
      );
      await UserInformations.insertUserInfo(user);
      status = SaveUserInfoStatus.success;
    } catch (e) {
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
                  child: (_profilePhoto == null)
                      ? PopupMenuButton(
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
                              onTap: () {
                                getImageFromGallery();
                              },
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
                              onTap: () {
                                getImageFromCamera();
                              },
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
                        )
                      : PopupMenuButton(
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
                              onTap: () {
                                getImageFromGallery();
                              },
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
                              onTap: () {
                                getImageFromCamera();
                              },
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
                              onTap: () {
                                setState(() => _profilePhoto = null);
                              },
                            ),
                          ],
                          child: Container(
                            width: 120.w,
                            height: 120.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.r),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(_profilePhoto!),
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
                        style: GoogleFonts.encodeSans(color: lightColor),
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'npr. Marko Marković',
                        ),
                        validator: (value) {
                          if (value!.length < 5 ||
                              value.length > 50 ||
                              !RegExp(r"^[a-žA-Ž\s]").hasMatch(value)) {
                            return 'Vaše ime mora sadržati najmanje 5 karaktera i najviše 50 karaktera. Takođe vaše ime može sadržati samo slova.';
                          } else {
                            setState(() => _name = value);
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
                    Align(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150.w, 65.h),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => saveUserInfoStatus =
                                SaveUserInfoStatus.loading);
                            final SaveUserInfoStatus result =
                                await _saveUserInfo();
                            if (result == SaveUserInfoStatus.success) {
                              try {
                                Navigator.pushReplacementNamed(context, '/');
                              } catch (e) {
                                // ignore: avoid_print
                                print(e);
                              }
                            } else if (result == SaveUserInfoStatus.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: backgroundColor,
                                  content: Text(
                                    errorMessage.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child:
                            (saveUserInfoStatus == SaveUserInfoStatus.loading)
                                ? SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: const CircularProgressIndicator(
                                      color: lightColor,
                                    ),
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
