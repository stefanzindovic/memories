import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/presentation/widgets/collection_card.dart';

class CollectionsFragment extends StatelessWidget {
  const CollectionsFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 20.w,
          title: const Text(
            'Kolekcije',
            overflow: TextOverflow.fade,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add-collection');
                },
                icon: Icon(
                  FeatherIcons.plus,
                  size: 30.w,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 20.w),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CollectionCard(),
                    CollectionCard(),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CollectionCard(),
                    CollectionCard(),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CollectionCard(),
                    CollectionCard(),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CollectionCard(),
                    CollectionCard(),
                  ],
                ),
                SizedBox(height: 20.h)
              ],
            ),
          ),
        ));
  }
}
