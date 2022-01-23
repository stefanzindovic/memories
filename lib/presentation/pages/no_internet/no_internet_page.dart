import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(20.w, 0.h, 20.h, 0.h),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Text(
              'Nema internet konekcije',
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Molimo vas da provjerite stanje vaše internet konekcije. Kada se stanje vaše internet konekcije vrati u normalu, kontent unutar aplikacije će se automatski prikazati.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
