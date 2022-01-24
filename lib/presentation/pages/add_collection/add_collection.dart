import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memories/models/collection.dart';
import 'package:memories/models/user.dart';
import 'package:memories/providers/user_data_provider.dart';
import 'package:memories/repository/collections_informations.dart';
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

  Future<SaveCollectionStatus> _saveCollection() async {
    SaveCollectionStatus status = _saveCollectionStatus;
    String collectionId =
        '${DateTime.now().microsecondsSinceEpoch.toString()}${_user!.uid}';
    String? coverPhotoUrl;
    try {
      if (_coverPhoto != null) {
        coverPhotoUrl = await CollectionsInformations.uploadCoverPhoto(
            collectionId, _coverPhoto!);
      }
      final collection = CollectionModel(
        id: collectionId,
        title: _title,
        coverPhotoUrl: coverPhotoUrl,
        authorId: _user!.uid,
      );
      await CollectionsInformations.createNewCollection(collection);
      status = SaveCollectionStatus.success;
    } on FirebaseException catch (e) {
      if (e.code == 'network-request-failed') {
        errorMessage =
            'Internet konekcija nije ostvarena. Molimo vas da provjerite vašu internet vezu i pokušajte ponovo.';
      }
    } catch (e) {
      errorMessage =
          'Došlo je do neočekivane greške pri kreiranju nove kolekcije. Molimo vas da pokušate ponovo.';
      status = SaveCollectionStatus.error;
    }
    return status;
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() =>
                      _saveCollectionStatus = SaveCollectionStatus.loading);
                  final SaveCollectionStatus result = await _saveCollection();
                  if (result == SaveCollectionStatus.success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: backgroundColor,
                        content: Text(
                          'Nova kolekcija je uspješno kreirana!',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    );
                  } else if (result == SaveCollectionStatus.error) {
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
                      _saveCollectionStatus = SaveCollectionStatus.initial);
                }
              },
              icon: (_saveCollectionStatus == SaveCollectionStatus.loading)
                  ? SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: const CircularProgressIndicator(
                        color: lightColor,
                      ),
                    )
                  : Icon(
                      FeatherIcons.check,
                      size: 30.w,
                    ),
            ),
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
