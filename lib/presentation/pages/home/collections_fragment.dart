import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/models/collection.dart';
import 'package:memories/presentation/widgets/collection_card.dart';
import 'package:memories/providers/collection_data_proivder.dart';
import 'package:provider/provider.dart';

class CollectionsFragment extends StatelessWidget {
  const CollectionsFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<CollectionModel?> _collections =
        Provider.of<CollectionDataProvoder>(context).collections;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          child: (_collections.isEmpty)
              ? Center(
                  child: Text(
                    'Nema kolekcija',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                )
              : GridView.count(
                  padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0.w,
                  mainAxisSpacing: 40.0.h,
                  children: [
                    for (var collection in _collections)
                      CollectionCard(
                        collection: collection!,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
