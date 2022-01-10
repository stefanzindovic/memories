import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoritesFragment extends StatelessWidget {
  const FavoritesFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20.w,
        title: const Text(
          'Najdraže uspomene',
          overflow: TextOverflow.fade,
        ),
      ),
      body: const Center(
        child: Text('Najdraže uspomene'),
      ),
    );
  }
}
