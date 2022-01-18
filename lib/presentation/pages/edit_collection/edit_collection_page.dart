import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memories/models/collection.dart';
import 'package:memories/repository/collections_informations.dart';
import 'package:memories/theme/colors.dart';

enum UpdateCollectionStatus {
  initial,
  loading,
  error,
  success,
}

class EditCollectionPage extends StatefulWidget {
  final Map data;
  const EditCollectionPage({Key? key, required this.data}) : super(key: key);

  @override
  _EditCollectionPageState createState() => _EditCollectionPageState();
}

class _EditCollectionPageState extends State<EditCollectionPage> {
  TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  File? _coverPhoto;
  bool _coverPhotoIsRemoved = false;
  UpdateCollectionStatus _updateCollectionStatus =
      UpdateCollectionStatus.initial;
  String? errorMessage;
  CollectionModel? _collection;

  Future<UpdateCollectionStatus> _updateCollection() async {
    UpdateCollectionStatus status = _updateCollectionStatus;
    String? coverPhotoUrl = widget.data['coverPhotoUrl'];
    try {
      if (_coverPhotoIsRemoved == true) {
        coverPhotoUrl = null;
        await CollectionsInformations.deleteCollectionCoverPhotoFromStorage(
            widget.data['id']);
      } else if (_coverPhoto != null) {
        coverPhotoUrl = await CollectionsInformations.uploadCoverPhoto(
            widget.data['id'], _coverPhoto!);
      }
      _collection = CollectionModel(
          id: widget.data['id'],
          title: _title,
          coverPhotoUrl: coverPhotoUrl,
          authorId: widget.data['authorId']);
      await CollectionsInformations.updateCollection(_collection!);
      print('Sve je u redu');
      status = UpdateCollectionStatus.success;
    } catch (e) {
      print(e);
      status = UpdateCollectionStatus.error;
      errorMessage =
          'Došlo je do neočekivane greške pri izmjeni podataka ove kolekcije. Molimo vas da pokušate ponovo.';
    }
    return status;
  }

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
  void initState() {
    _controller = TextEditingController(text: 'Naslov kolekcije');
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.text = widget.data['title'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izmijenite kolekciju'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _updateCollectionStatus =
                        UpdateCollectionStatus.loading);
                    final UpdateCollectionStatus result =
                        await _updateCollection();
                    if (result == UpdateCollectionStatus.success) {
                      //print("Kolekcija ${_collection!.toJson()}");
                      Navigator.pop(
                        context,
                        _collection!.toJson(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: backgroundColor,
                          content: Text(
                            'Uspješno ste izmijenili informacije o kolekciji "${_title}".',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      );
                    }
                    setState(() => _updateCollectionStatus =
                        UpdateCollectionStatus.initial);
                  }
                },
                icon:
                    (_updateCollectionStatus == UpdateCollectionStatus.loading)
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
                  child: (widget.data['coverPhotoUrl'] == null ||
                          _coverPhotoIsRemoved == true)
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
                                setState(() => _coverPhotoIsRemoved = false);
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
                                setState(() => _coverPhotoIsRemoved = false);
                              },
                            ),
                          ],
                          child: (_coverPhoto == null)
                              ? Container(
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
                                )
                              : Container(
                                  width: double.infinity,
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.r),
                                    color: backgroundColor,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          widget.data['coverPhotoUrl']),
                                      fit: BoxFit.cover,
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
                                setState(() => _coverPhotoIsRemoved = false);
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
                                setState(() => _coverPhotoIsRemoved = false);
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
                                setState(() => _coverPhotoIsRemoved = true);
                              },
                            ),
                          ],
                          child: (_coverPhoto == null)
                              ? Container(
                                  width: double.infinity,
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.r),
                                    color: backgroundColor,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          widget.data['coverPhotoUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
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
                        controller: _controller,
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
