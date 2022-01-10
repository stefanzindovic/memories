import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/theme/colors.dart';

class EditUserInfoPage extends StatelessWidget {
  const EditUserInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podešavanja profila'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  FeatherIcons.check,
                  size: 30.w,
                )),
          ),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0.h),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              FeatherIcons.image,
                              color: lightColor,
                            ),
                            SizedBox(
                              width: 10.h,
                            ),
                            const Text('Fotografija iz galerije'),
                          ],
                        ),
                        value: 'pick-from-gallery',
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              FeatherIcons.camera,
                              color: lightColor,
                            ),
                            SizedBox(
                              width: 10.h,
                            ),
                            const Text('Fotografija sa kamere'),
                          ],
                        ),
                        value: 'pick-from-camera',
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              FeatherIcons.trash2,
                              color: lightColor,
                            ),
                            SizedBox(
                              width: 10.h,
                            ),
                            const Text('Uklonite profinu fotografiju'),
                          ],
                        ),
                        value: 'remove-profile-photo',
                        onTap: () {},
                      ),
                    ],
                    child: Container(
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
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ime i prezime'),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        style: const TextStyle(color: lightColor),
                        decoration: const InputDecoration(
                          hintText: 'npr. Marko Marković',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
