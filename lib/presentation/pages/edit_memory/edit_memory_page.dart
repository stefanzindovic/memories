import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memories/models/collection.dart';
import 'package:memories/models/memory.dart';
import 'package:memories/providers/collection_data_proivder.dart';
import 'package:memories/repository/memory_informations.dart';
import 'package:memories/theme/colors.dart';
import 'package:provider/provider.dart';

enum UpdateMemoryStatus {
  initial,
  loading,
  success,
  error,
}

class EditMemoryPage extends StatefulWidget {
  final Map data;
  const EditMemoryPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _EditMemoryPageState createState() => _EditMemoryPageState();
}

class _EditMemoryPageState extends State<EditMemoryPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _storyController = TextEditingController();
  String _collectionId = 'no-collection';
  String _title = '';
  String _story = '';
  File? _coverPhoto;
  bool _coverPhotoIsRemoved = false;
  final _formKey = GlobalKey<FormState>();
  UpdateMemoryStatus _updateMemoryInfoStatus = UpdateMemoryStatus.initial;
  String? errorMessage;
  MemoryModel? _memory;

  Future<UpdateMemoryStatus> updateMemory() async {
    UpdateMemoryStatus status = _updateMemoryInfoStatus;
    String? coverPhotoUrl = widget.data['coverPhotoUrl'];
    try {
      if (_coverPhotoIsRemoved == true) {
        coverPhotoUrl = null;
        await MemoryInformations.deleteMemoryCoverPhoto(widget.data['id']);
      } else if (_coverPhoto != null) {
        coverPhotoUrl = await MemoryInformations.uploadMemoryCoverPhoto(
            widget.data['id'], _coverPhoto!);
      }
      _memory = MemoryModel(
          id: widget.data['id'],
          title: _title,
          story: _story,
          collectionId: _collectionId,
          authorId: widget.data['authorId'],
          coverPhotoUrl: coverPhotoUrl,
          createdAt: widget.data['createdAt'],
          isFavorite: widget.data['isFavorite']);
      await MemoryInformations.updateMemory(_memory!);
      print('Sve je u redu');
      status = UpdateMemoryStatus.success;
    } catch (e) {
      errorMessage =
          'Došlo je do neočekovane greške pri izmjeni podataka o ovoj uspomeni. Molimo vas da pokušate ponovo.';
      print(e);
      status = UpdateMemoryStatus.error;
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
    _titleController = TextEditingController(text: 'Naslov uspomene');
    _storyController = TextEditingController(text: 'Sadržaj uspomene');
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _titleController.text = widget.data['title'];
      _storyController.text = widget.data['story'];
      _collectionId = widget.data['collectionId'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Izmijenite uspomenu'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() =>
                      _updateMemoryInfoStatus = UpdateMemoryStatus.loading);
                  final UpdateMemoryStatus result = await updateMemory();
                  if (result == UpdateMemoryStatus.success) {
                    //print("Kolekcija ${_collection!.toJson()}");
                    Navigator.pop(
                      context,
                      _memory!.toJson(),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: backgroundColor,
                        content: Text(
                          'Uspješno ste izmijenili informacije o uspomeni "$_title".',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    );
                  }
                  setState(() =>
                      _updateMemoryInfoStatus = UpdateMemoryStatus.initial);
                }
              },
              icon: (_updateMemoryInfoStatus == UpdateMemoryStatus.loading)
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
                                      image: FileImage(_coverPhoto!),
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
                        controller: _titleController,
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
                              borderRadius: BorderRadius.circular(7.r),
                              dropdownColor: backgroundColor,
                              style: Theme.of(context).textTheme.bodyText2,
                              hint: Text(
                                'Opšte (Nema kolekcije)',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              items: _dropdownList,
                              onChanged: (index) {
                                setState(() => _collectionId = index);
                              },
                              value: _collectionId,
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
                        controller: _storyController,
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
