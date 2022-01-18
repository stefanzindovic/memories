import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/models/collection.dart';
import 'package:memories/theme/colors.dart';

class CollectionCard extends StatelessWidget {
  CollectionModel collection;
  CollectionCard({
    Key? key,
    required this.collection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final data = collection.toJson();
        Navigator.pushNamed(
          context,
          '/collection',
          arguments: data,
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (collection.coverPhotoUrl == null)
              ? Container(
                  width: 140.w,
                  height: 140.h,
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
                  width: 140.w,
                  height: 140.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.r),
                    color: backgroundColor,
                    image: DecorationImage(
                      image: NetworkImage(collection.coverPhotoUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          SizedBox(height: 3.h),
          Text(
            collection.title,
            style: Theme.of(context).textTheme.headline3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
