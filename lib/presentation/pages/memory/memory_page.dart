import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:memories/models/collection.dart';
import 'package:memories/providers/collection_data_proivder.dart';
import 'package:memories/repository/collections_informations.dart';
import 'package:memories/repository/memory_informations.dart';
import 'package:memories/theme/colors.dart';
import 'package:provider/provider.dart';

enum DeleteMemoryStatus {
  initial,
  loading,
  success,
  error,
}

enum ChangeMemoryFavoriteStatusStatus {
  initial,
  loading,
  success,
  error,
}

class MemoryPage extends StatefulWidget {
  final Map data;
  const MemoryPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _MemoryPageState createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  String? errorMessage;
  DeleteMemoryStatus _deleteMemoryStatus = DeleteMemoryStatus.initial;
  ChangeMemoryFavoriteStatusStatus _changeMemoryFavoriteStatusStatus =
      ChangeMemoryFavoriteStatusStatus.initial;
  Map? editedInfo;

  Future<ChangeMemoryFavoriteStatusStatus> _changeMemoryFavoriteState() async {
    ChangeMemoryFavoriteStatusStatus status = _changeMemoryFavoriteStatusStatus;
    try {
      await MemoryInformations.changeMemoryFavoriteState(
          widget.data['data']['id'], !widget.data['data']['isFavorite']);
      status = ChangeMemoryFavoriteStatusStatus.success;
      print('Sve je u redu!');
    } catch (e) {
      print(e);
      if (widget.data['data']['isFavorite'] == true) {
        errorMessage =
            'Došlo je do neočekivane greške pri uklanjanju ove uspomene sa liste vaših najdražih uspomena. Molimo vas da pokušate ponovo.';
      } else {
        errorMessage =
            'Došlo je do neočekivane greške pri dodavanju ove uspomene na listu vaših najdražih uspomena. Molimo vas da pokušate ponovo.';
      }
      status = ChangeMemoryFavoriteStatusStatus.error;
    }
    return status;
  }

  Future<DeleteMemoryStatus> _deleteMemory() async {
    DeleteMemoryStatus status = _deleteMemoryStatus;
    try {
      await MemoryInformations.deleteMemory(widget.data['data']['id']);
      print('Sve je u redu');
      status = DeleteMemoryStatus.success;
    } catch (e) {
      print(e);
      status = DeleteMemoryStatus.error;
      errorMessage =
          'Došlo je do neočekivane greške pri brisanju ove uspomene. Molimo vas da pokušate ponovo.';
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    String? _collectionTitle = widget.data['collection_name'];

    if (editedInfo != null &&
        widget.data['data']['collectionId'] != editedInfo?['collectionId']) {
      final List<CollectionModel?> _collections =
          Provider.of<CollectionDataProvoder>(context).collections;
      for (var collection in _collections) {
        if (collection!.id == editedInfo?['collectionId']) {
          setState(() => _collectionTitle = collection.title);
        }
      }
    }
    print(widget.data);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          editedInfo?['title'] ?? widget.data['data']['title'],
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: PopupMenuButton(
              onSelected: (result) async {
                switch (result) {
                  case 'favorite-memory':
                    final ChangeMemoryFavoriteStatusStatus result =
                        await _changeMemoryFavoriteState();
                    if (result == ChangeMemoryFavoriteStatusStatus.success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: backgroundColor,
                          content: (widget.data['data']['isFavorite'] == false)
                              ? Text(
                                  'Uspomena "${editedInfo?['title'] ?? widget.data['data']['title']}" je uspješno dodata na listi vaših omiljenih uspomena',
                                  style: Theme.of(context).textTheme.bodyText2,
                                )
                              : Text(
                                  'Uspomena "${editedInfo?['title'] ?? widget.data['data']['title']}" je uspješno obrisana sa liste vaših omiljenih uspomena',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                        ),
                      );
                    }
                    break;
                  case 'edit-memory':
                    editedInfo = await Navigator.pushNamed(
                        context, '/edit-memory',
                        arguments: editedInfo ?? widget.data['data']) as Map?;
                    setState(() => editedInfo = editedInfo);
                    if (editedInfo != null) {
                      widget.data['data']['coverPhotoUrl'] =
                          editedInfo?['coverPhotoUrl'];
                    }
                    break;

                  case 'delete-memory':
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: backgroundColor,
                          title: Text(
                            'Da li želite da obrišete uspomenu "${editedInfo?['title'] ?? widget.data['data']['title']}"?',
                            style: GoogleFonts.encodeSans(
                              color: lightColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          content: Text(
                            'U slučaju brisanja ove uspomene, sve informacije koje su vezane za nju će biti trajno obrisani. Ako ste sigurni da želite da obrišete ovu uspomenu koristite dugme "Nastavite"',
                            style: GoogleFonts.encodeSans(
                              color: textColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Odustanite'),
                              style: TextButton.styleFrom(
                                primary: lightColor,
                                textStyle: GoogleFonts.encodeSans(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                setState(() => _deleteMemoryStatus =
                                    DeleteMemoryStatus.loading);
                                final DeleteMemoryStatus status =
                                    await _deleteMemory();
                                if (status == DeleteMemoryStatus.error) {
                                } else if (status ==
                                    DeleteMemoryStatus.success) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: backgroundColor,
                                      content: Text(
                                        'Uspomena "${editedInfo?['title'] ?? widget.data['data']['title']} je uspješno obrisana"',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ),
                                  );
                                }
                                setState(() => _deleteMemoryStatus =
                                    DeleteMemoryStatus.initial);
                              },
                              child: (_deleteMemoryStatus ==
                                      DeleteMemoryStatus.loading)
                                  ? SizedBox(
                                      width: 24.w,
                                      height: 24.h,
                                      child: const CircularProgressIndicator(
                                          color: lightColor),
                                    )
                                  : Text('Dalje'),
                              style: ElevatedButton.styleFrom(
                                primary: errorColor,
                                minimumSize: Size(90.w, 65.h),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    break;
                }
              },
              child: Icon(
                FeatherIcons.moreVertical,
                size: 30.w,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'favorite-memory',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FeatherIcons.heart,
                        size: 24.w,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      (widget.data['data']['isFavorite'] == true)
                          ? const Text('Uklonite iz omiljenih')
                          : const Text('Dodajte u omiljene'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'edit-memory',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FeatherIcons.edit3,
                        size: 24.w,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      const Text('Izmijenite uspomenu'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete-memory',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FeatherIcons.trash2,
                        size: 24.w,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      const Text('Obrišite uspomenu'),
                    ],
                  ),
                ),
              ],
            ),
          )
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
                (widget.data['data']['coverPhotoUrl'] == null &&
                        editedInfo?['coverPhotoUrl'] == null)
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
                            image: NetworkImage(editedInfo?['coverPhotoUrl'] ??
                                widget.data['data']['coverPhotoUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                SizedBox(
                  height: 20.h,
                ),
                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            FeatherIcons.calendar,
                            size: 25,
                            color: textColor,
                          ),
                          SizedBox(width: 5.w),
                          SizedBox(
                            width: ((MediaQuery.of(context).size.width - 40.w) /
                                    3) -
                                50.w,
                            child: Text(
                              DateFormat('dd-MM-yy').format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                  widget.data['data']['createdAt'],
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            FeatherIcons.clock,
                            size: 25,
                            color: textColor,
                          ),
                          SizedBox(width: 5.w),
                          SizedBox(
                            width: ((MediaQuery.of(context).size.width - 40.w) /
                                    3) -
                                50.w,
                            child: Text(
                              DateFormat('HH:mm').format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                  widget.data['data']['createdAt'],
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            FeatherIcons.grid,
                            size: 25,
                            color: textColor,
                          ),
                          SizedBox(width: 5.w),
                          SizedBox(
                            width: ((MediaQuery.of(context).size.width - 40.w) /
                                    3) -
                                50.w,
                            child: Text(
                              _collectionTitle ?? 'Opšte',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  editedInfo?['story'] ?? widget.data['data']['story'],
                  style: Theme.of(context).textTheme.bodyText1,
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
