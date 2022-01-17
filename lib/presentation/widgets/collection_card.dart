import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/theme/colors.dart';

class CollectionCard extends StatelessWidget {
  final String title;
  final String? coverPhotoUrl;
  final String collectionId;
  const CollectionCard({
    Key? key,
    required this.title,
    required this.coverPhotoUrl,
    required this.collectionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final Object arguments = {
          'id': collectionId,
          'title': title,
          'coverPhotoUrl': coverPhotoUrl,
        };
        Navigator.pushNamed(context, '/collection', arguments: arguments);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (coverPhotoUrl == null)
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
                      image: NetworkImage(coverPhotoUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          SizedBox(height: 3.h),
          Text(
            title,
            style: Theme.of(context).textTheme.headline3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
