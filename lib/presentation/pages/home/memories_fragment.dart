import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/models/memory.dart';
import 'package:memories/presentation/widgets/memory_card.dart';
import 'package:memories/providers/memory_data_provider.dart';
import 'package:provider/provider.dart';

class MemoriesFragment extends StatelessWidget {
  const MemoriesFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MemoryModel?> _memories =
        Provider.of<MemoryDataProvider>(context).memories;
    final List<Widget> _memoryCardsList = [];

    for (var memory in _memories.reversed) {
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
          'Uspomene',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-memory');
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
                  )),
      ),
    );
  }
}
