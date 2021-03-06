import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memories/models/collection.dart';
import 'package:memories/models/memory.dart';
import 'package:memories/providers/collection_data_proivder.dart';
import 'package:memories/providers/memory_data_provider.dart';
import 'package:memories/providers/user_data_provider.dart';
import 'package:memories/theme/colors.dart';
import 'package:provider/provider.dart';

class ProfileFragment extends StatelessWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _favoriteMemories =
        Provider.of<MemoryDataProvider>(context).favoriteMemories;
    final _user = Provider.of<UserDataProvider>(context).userData;
    final List<CollectionModel?> _collections =
        Provider.of<CollectionDataProvoder>(context).collections;
    final List<MemoryModel?> _memories =
        Provider.of<MemoryDataProvider>(context).memories;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: Text(
          _user?.name ?? 'Name',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              icon: Icon(
                FeatherIcons.settings,
                size: 25.w,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(20.w, 0.h, 20.h, 0.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.h,
            ),
            (_user?.profilePhotoUrl == null)
                ? Container(
                    width: 120.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.r),
                      color: backgroundColor,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        FeatherIcons.user,
                        size: 50.w,
                      ),
                    ),
                  )
                : Container(
                    width: 120.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.r),
                      color: backgroundColor,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(_user!.profilePhotoUrl.toString()),
                      ),
                    ),
                  ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _memories.length.toString(),
                          style: GoogleFonts.encodeSans(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'Uspomene',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _favoriteMemories.length.toString(),
                          style: GoogleFonts.encodeSans(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'Najdra??e',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _collections.length.toString(),
                          style: GoogleFonts.encodeSans(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'Kolekcije',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
