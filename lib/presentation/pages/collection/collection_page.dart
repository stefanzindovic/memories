import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memories/models/memory.dart';
import 'package:memories/presentation/widgets/memory_card.dart';
import 'package:memories/providers/current_user_provider.dart';
import 'package:memories/providers/memory_data_provider.dart';
import 'package:memories/repository/collections_informations.dart';
import 'package:memories/repository/memory_informations.dart';
import 'package:memories/theme/colors.dart';
import 'package:provider/provider.dart';

enum DeleteCollectionStatus {
  initial,
  success,
  error,
  loading,
}

// ignore: must_be_immutable
class CollectionPage extends StatefulWidget {
  Map data;
  CollectionPage({Key? key, required this.data}) : super(key: key);

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  String? errorMessage;
  Map? editedInfo;
  DeleteCollectionStatus _deleteCollectionStatus =
      DeleteCollectionStatus.initial;
  List<MemoryModel?> memories = [];

  Future<DeleteCollectionStatus> _deleteCollection() async {
    DeleteCollectionStatus status = DeleteCollectionStatus.initial;
    try {
      await CollectionsInformations.deleteCollection(widget.data['id']);
      for (var memory in memories) {
        if (memory != null) {
          MemoryModel model = MemoryModel(
              id: memory.id,
              title: memory.title,
              story: memory.story,
              collectionId: 'no-collection',
              authorId: memory.authorId,
              coverPhotoUrl: memory.coverPhotoUrl,
              createdAt: memory.createdAt,
              isFavorite: memory.isFavorite);
          await MemoryInformations.updateMemory(model);
        }
      }
      status = DeleteCollectionStatus.success;
    } catch (e) {
      errorMessage =
          'Došlo je do neočekivane greške pri brisanju ove kolekcije. Molimo vas da pokušate ponovo.';
      status = DeleteCollectionStatus.error;
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final String _uid =
        Provider.of<CurrentUserProvider>(context).uid.toString();
    Provider.of<MemoryDataProvider>(context)
        .setMemoriesByCollection(_uid, widget.data['id']);
    setState(() =>
        memories = Provider.of<MemoryDataProvider>(context).collectionMemories);

    final List<Widget> _memoryCardsList = [];

    for (var memory in memories.reversed) {
      _memoryCardsList.add(MemoryCard(memory: memory));
      _memoryCardsList.add(
        SizedBox(
          height: 20.h,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editedInfo?['title'] ?? widget.data['title'],
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: PopupMenuButton(
              onSelected: (result) async {
                switch (result) {
                  case 'edit-collection':
                    editedInfo = await Navigator.pushNamed(
                            context, '/edit-collection',
                            arguments: editedInfo ?? widget.data)
                        as Map<dynamic, dynamic>?;
                    setState(() => editedInfo = editedInfo);
                    if (editedInfo != null) {
                      widget.data['coverPhotoUrl'] =
                          editedInfo?['coverPhotoUrl'];
                    }
                    break;
                  case 'delete-collection':
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: backgroundColor,
                          title: Text(
                            'Da li želite da obrišete uspomenu "${editedInfo?['title'] ?? widget.data['title'] ?? 'Test'}"?',
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
                                setState(() => _deleteCollectionStatus =
                                    DeleteCollectionStatus.loading);
                                final DeleteCollectionStatus result =
                                    await _deleteCollection();
                                if (result == DeleteCollectionStatus.success) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: backgroundColor,
                                      content: Text(
                                        'Uspješno ste obrisali kolekciju "${widget.data['title']}"',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ),
                                  );
                                } else if (result ==
                                    DeleteCollectionStatus.error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: backgroundColor,
                                      content: Text(
                                        errorMessage.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ),
                                  );
                                }
                                setState(() => _deleteCollectionStatus =
                                    DeleteCollectionStatus.initial);
                              },
                              child: (_deleteCollectionStatus ==
                                      DeleteCollectionStatus.loading)
                                  ? SizedBox(
                                      width: 24.w,
                                      height: 24.h,
                                      child: const CircularProgressIndicator(
                                          color: lightColor),
                                    )
                                  : const Text('Dalje'),
                              style: ElevatedButton.styleFrom(
                                primary: errorColor,
                                minimumSize: Size(90.w, 65.h),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                }
              },
              child: Icon(
                FeatherIcons.moreVertical,
                size: 30.w,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit-collection',
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
                      const Text('Izmijenite kolekciju'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete-collection',
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
                      const Text('Obrišite kolekciju'),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
                (widget.data['coverPhotoUrl'] == null &&
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
                            image: NetworkImage(
                              editedInfo?['coverPhotoUrl'] ??
                                  widget.data['coverPhotoUrl'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                SizedBox(
                  height: 20.h,
                ),
                Text('${memories.length} uspomene'),
                SizedBox(
                  height: 20.h,
                ),
                (_memoryCardsList.isEmpty)
                    ? Center(
                        child: Text('Nema uspomena',
                            style: Theme.of(context).textTheme.bodyText1),
                      )
                    : Column(
                        children: _memoryCardsList,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
