import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/presentation/pages/home/collections_fragment.dart';
import 'package:memories/presentation/pages/home/favorites_fragment.dart';
import 'package:memories/presentation/pages/home/memories_fragment.dart';
import 'package:memories/presentation/pages/home/profile_fragment.dart';
import 'package:memories/theme/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List _pages = [
    MemoriesFragment(),
    CollectionsFragment(),
    FavoritesFragment(),
    ProfileFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: darkColor,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              spreadRadius: 0.r,
              blurRadius: 4.r,
              offset: Offset(0.w, -1.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.w, 8.h, 0.w, 9.h),
          child: BottomNavigationBar(
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: const Icon(FeatherIcons.home),
                ),
                label: 'Uspomene',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: const Icon(FeatherIcons.grid),
                ),
                label: 'Kolekcije',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: const Icon(FeatherIcons.heart),
                ),
                label: 'Najdraže',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: const Icon(FeatherIcons.user),
                ),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
