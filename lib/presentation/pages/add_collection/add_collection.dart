import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memories/models/user.dart';
import 'package:memories/providers/user_data_provider.dart';
import 'package:memories/repository/user_informations.dart';
import 'package:memories/theme/colors.dart';
import 'package:provider/provider.dart';

enum SaveCollectionStatus {
  initial,
  loading,
  success,
  error,
}

class AddCollectionPage extends StatefulWidget {
  const AddCollectionPage({Key? key}) : super(key: key);

  @override
  _AddCollectionPageState createState() => _AddCollectionPageState();
}

class _AddCollectionPageState extends State<AddCollectionPage> {
  final _formKey = GlobalKey<FormState>();
  UserModel? _user;
  String _title = '';
  File? _coverPhoto;
  SaveCollectionStatus _saveCollectionStatus = SaveCollectionStatus.initial;
  String? errorMessage;

  Future getImageFromGallery() async {
    ImagePicker _picker = ImagePicker();
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _coverPhoto = File(file.path));
    }
  }

  Future getImageFromCamera() async {
    ImagePicker _picker = ImagePicker();
    XFile? file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      setState(() => _coverPhoto = File(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<UserDataProvider>(context).userData;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova kolekcija'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
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
                  child: (_coverPhoto == null)
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
                            width: double.infinity,
                            height: 150.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.r),
                              color: backgroundColor,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                FeatherIcons.image,
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
                                  const Text('Uklonite naslovnu fotografiju'),
                                ],
                              ),
                              value: 'remove-cover-photo',
                              onTap: () {
                                setState(() => _coverPhoto = null);
                              },
                            ),
                          ],
                          child: Container(
                            width: double.infinity,
                            height: 150.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.r),
                              color: backgroundColor,
                              image: DecorationImage(
                                image: FileImage(_coverPhoto!),
                                fit: BoxFit.cover,
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
                      const Text('Naslov'),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(
                          color: lightColor,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'npr. "Psi", "Porodica", "Putovanja", ...',
                        ),
                        validator: (value) {
                          if (value!.length < 2 ||
                              value.length > 50 ||
                              !RegExp(r"^[a-zA-Z\s]").hasMatch(value)) {
                            return 'Naslov vaše kolekcije mora sadržati najmanje 2 karaktera i najviše 50 karaktera. Takođe naslov vaše kolekcije može sadržati slova, brojeve i znakove.';
                          } else {
                            setState(() => _title = value);
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
