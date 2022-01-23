import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/presentation/widgets/memory_card.dart';
import 'package:memories/providers/current_user_provider.dart';
import 'package:memories/providers/memory_data_provider.dart';
import 'package:provider/provider.dart';

class FavoritesFragment extends StatelessWidget {
  const FavoritesFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _favoriteMemories =
        Provider.of<MemoryDataProvider>(context).favoriteMemories;

    final List<Widget> _memoryCardsList = [];

    for (var memory in _favoriteMemories.reversed) {
      _memoryCardsList.add(MemoryCard(memory: memory));
      _memoryCardsList.add(
        SizedBox(
          height: 20.h,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: const Text(
          'Najdraže uspomene',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20.h),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: (_memoryCardsList.isEmpty)
              ? Center(
                  child: Text(
                    'Nema uspomena',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                )
              : ListView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  children: _memoryCardsList,
                ),
        ),
      ),
    );
  }
}
