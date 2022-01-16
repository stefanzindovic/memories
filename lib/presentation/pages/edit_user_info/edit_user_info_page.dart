import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memories/models/user.dart';
import 'package:memories/providers/user_data_provider.dart';
import 'package:memories/theme/colors.dart';
import 'package:provider/provider.dart';

enum UpdateUserInfoStatus {
  initial,
  loading,
  success,
  failed,
}

class EditUserInfoPage extends StatefulWidget {
  const EditUserInfoPage({Key? key}) : super(key: key);

  @override
  _EditUserInfoPageState createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  TextEditingController _controller = TextEditingController();
  UserModel? _user;
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  File? _profilePhoto;
  String? _profilePhotoUrl;
  bool _profilePictureIsRemoved = false;

  @override
  void initState() {
    _controller = TextEditingController(text: 'Vaše ime i prezime');
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _user = context.read<UserDataProvider>().userData;
      _controller.text = _user!.name;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<UserDataProvider>(context).userData;
    setState(() => _profilePhotoUrl = _user?.profilePhotoUrl);

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Podešavanja profila'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  FeatherIcons.check,
                  size: 30.w,
                )),
          ),
        ],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: (_profilePhotoUrl == null ||
                          _profilePictureIsRemoved == true)
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
                                setState(
                                    () => _profilePictureIsRemoved = false);
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
                                setState(
                                    () => _profilePictureIsRemoved = false);
                              },
                            ),
                          ],
                          child: (_profilePhoto == null)
                              ? Container(
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
                                )
                              : Container(
                                  width: 120.w,
                                  height: 120.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.r),
                                    color: backgroundColor,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(
                                        _profilePhoto!,
                                      ),
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
                                setState(() => _profilePhotoUrl = null);
                                setState(() => _profilePictureIsRemoved = true);
                              },
                            ),
                          ],
                          child: (_profilePhoto == null)
                              ? Container(
                                  width: 120.w,
                                  height: 120.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.r),
                                    color: backgroundColor,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        _profilePhotoUrl.toString(),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 120.w,
                                  height: 120.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.r),
                                    color: backgroundColor,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(
                                        _profilePhoto!,
                                      ),
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
                        style: const TextStyle(color: lightColor),
                        decoration: const InputDecoration(
                          hintText: 'npr. Marko Marković',
                        ),
                        controller: _controller,
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
