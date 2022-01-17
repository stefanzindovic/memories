import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/theme/colors.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Naslov kolekcije",
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
                Container(
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
