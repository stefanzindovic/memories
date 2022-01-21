import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memories/models/collection.dart';
import 'package:memories/models/memory.dart';
import 'package:memories/models/user.dart';
import 'package:memories/providers/collection_data_proivder.dart';
import 'package:memories/providers/user_data_provider.dart';
import 'package:memories/repository/memory_informations.dart';
import 'package:memories/theme/colors.dart';
import 'package:provider/provider.dart';

enum CreateMemoryStatus {
  initial,
  loading,
  success,
  error,
}

class AddMemoryPage extends StatefulWidget {
  const AddMemoryPage({Key? key}) : super(key: key);

  @override
  _AddMemoryPageState createState() => _AddMemoryPageState();
}

class _AddMemoryPageState extends State<AddMemoryPage> {
  final _formKey = GlobalKey<FormState>();
  CreateMemoryStatus _createMemoryStatus = CreateMemoryStatus.initial;
  String _title = '';
  String _story = '';
  String _collectionId = 'no-collection';
  File? _coverPhoto;
  String? errorMessage;
  UserModel? _user;

  Future<void> getImageFromGallery() async {
    ImagePicker _picker = ImagePicker();
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _coverPhoto = File(file.path));
    }
  }

  Future<void> getImageFromCamera() async {
    ImagePicker _picker = ImagePicker();
    XFile? file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      setState(() => _coverPhoto = File(file.path));
    }
  }

  Future<CreateMemoryStatus> _createMemory() async {
    CreateMemoryStatus status = _createMemoryStatus;
    String memoryId =
        '${DateTime.now().microsecondsSinceEpoch.toString()}${_user!.uid}';
    String? coverPhotoUrl;
    try {
      if (_coverPhoto != null) {
        coverPhotoUrl = await MemoryInformations.uploadMemoryCoverPhoto(
            memoryId, _coverPhoto!);
      }
      print(_coverPhoto);
      final memory = MemoryModel(
        id: memoryId,
        title: _title,
        story: _story,
        collectionId: _collectionId,
        authorId: _user!.uid,
        coverPhotoUrl: coverPhotoUrl,
        createdAt: DateTime.now().microsecondsSinceEpoch,
        isFavorite: false,
      );
      await MemoryInformations.createNewMemory(memory);
      print('Sve je u redu.');
      status = CreateMemoryStatus.success;
    } catch (e) {
      print(e);
      status = CreateMemoryStatus.error;
      errorMessage =
          'Došlo je do neočekivane greške pri kreiranju nove uspomene. Molimo vas da pokušate ponovo.';
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<UserDataProvider>(context).userData;
    List<CollectionModel?> _collections =
        Provider.of<CollectionDataProvoder>(context).collections;
    List<DropdownMenuItem> _dropdownList = [
      const DropdownMenuItem(
        child: Text('Opšte (Nema kolekcije)'),
        value: 'no-collection',
      ),
    ];
    for (var collection in _collections) {
      _dropdownList.add(
        DropdownMenuItem(
          child: Text(collection!.title),
          value: collection.id,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova uspomena'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(
                      () => _createMemoryStatus = CreateMemoryStatus.loading);
                  final CreateMemoryStatus result = await _createMemory();
                  if (result == CreateMemoryStatus.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: backgroundColor,
                        content: Text(
                          errorMessage.toString(),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    );
                  } else if (result == CreateMemoryStatus.success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: backgroundColor,
                        content: Text(
                          'Uspješno ste kreirali uspomenu "$_title"',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    );
                  }
                  setState(
                      () => _createMemoryStatus = CreateMemoryStatus.initial);
                }
              },
              icon: (_createMemoryStatus == CreateMemoryStatus.loading)
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                          ))
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
                          hintText: 'npr. "Porodična večera", ...',
                        ),
                        validator: (value) {
                          if (value!.length < 2 ||
                              value.length > 50 ||
                              !RegExp(r"^[a-zA-Z0-9\s]").hasMatch(value)) {
                            return 'Naslov vaše uspomene mora sadržati najmanje 2 karaktera i najviše 50 karaktera. Takođe naslov vaše uspomene može sadržati slova, brojeve i znakove.';
                          } else {
                            setState(() => _title = value);
                          }
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      const Text('Kolekcija'),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.w,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<dynamic>(
                              value: _collectionId,
                              borderRadius: BorderRadius.circular(7.r),
                              dropdownColor: backgroundColor,
                              style: Theme.of(context).textTheme.bodyText2,
                              hint: Text(
                                'Opšte (Nema kolekcije)',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              items: _dropdownList,
                              onChanged: (value) {
                                setState(() => _collectionId = value);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      const Text('Uspomena/Priča'),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 5,
                        maxLines: 5,
                        maxLength: 1000000,
                        style: const TextStyle(
                          color: lightColor,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'npr. Dragi dnevniče ...',
                        ),
                        validator: (value) {
                          if (value!.length < 5 ||
                              value.length > 1000000 ||
                              !RegExp(r"^[a-zA-Z0-9\s]").hasMatch(value)) {
                            return 'Sadržaj vaše uspomene mora sadržati najmanje 5 karaktera i ne može biti duži od 1 000 000 karaktera. Takođe sadržaj vaše uspomene može sadržati slova, brojeve i znakove.';
                          } else {
                            setState(() => _story = value);
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
