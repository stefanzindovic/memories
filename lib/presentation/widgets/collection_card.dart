import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/theme/colors.dart';

class CollectionCard extends StatelessWidget {
  const CollectionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2 - 20.w,
        height: MediaQuery.of(context).size.width / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2 - 40,
              height: MediaQuery.of(context).size.width / 2 - 40,
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
            Text(
              'Doktor',
              style: Theme.of(context).textTheme.headline3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
