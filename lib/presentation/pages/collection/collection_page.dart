import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/repository/collections_informations.dart';
import 'package:memories/theme/colors.dart';

enum DeleteCollectionStatus {
  initial,
  success,
  error,
}

class CollectionPage extends StatelessWidget {
  final Map data;
  CollectionPage({Key? key, required this.data}) : super(key: key);

  String? errorMessage;

  Future<DeleteCollectionStatus> _deleteCollection() async {
    DeleteCollectionStatus status = DeleteCollectionStatus.initial;
    try {
      await CollectionsInformations.deleteCollection(data['id']);
      status = DeleteCollectionStatus.success;
      print('Sve je u redu!');
    } catch (e) {
      print(e);
      errorMessage =
          'Došlo je do neočekivane greške pri brisanju ove kolekcije. Molimo vas da pokušate ponovo.';
      status = DeleteCollectionStatus.error;
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data['title'],
          overflow: TextOverflow.fade,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: PopupMenuButton(
              child: Icon(
                FeatherIcons.moreVertical,
                size: 30.w,
              ),
              itemBuilder: (context) => [
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
                      const Text('Izmijenite kolekciju'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'edit-memory',
                  onTap: () async {
                    final DeleteCollectionStatus result =
                        await _deleteCollection();
                    if (result == DeleteCollectionStatus.success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: backgroundColor,
                          content: Text(
                            'Uspješno ste obrisali kolekciju "${data['title']}"',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      );
                    } else if (result == DeleteCollectionStatus.error) {
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
                  },
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
                (data['coverPhotoUrl'] == null)
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
                              data['coverPhotoUrl'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                SizedBox(
                  height: 20.h,
                ),
                const Text('2 uspomene'),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
