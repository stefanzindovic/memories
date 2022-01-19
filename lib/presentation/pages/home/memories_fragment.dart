import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/presentation/widgets/memory_card.dart';
import 'package:memories/repository/memory_informations.dart';

class MemoriesFragment extends StatelessWidget {
  const MemoriesFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: const Text(
          'Uspomene',
          overflow: TextOverflow.fade,
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
        child: ListView(
          children: [
            MemoryCard(),
            SizedBox(height: 20.h),
            MemoryCard(),
            SizedBox(height: 20.h),
            MemoryCard(),
            SizedBox(height: 20.h),
            MemoryCard(),
            SizedBox(height: 20.h),
            MemoryCard(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
