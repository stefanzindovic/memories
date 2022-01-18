import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memories/theme/colors.dart';

class EditMemoryPage extends StatefulWidget {
  final Map data;
  const EditMemoryPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _EditMemoryPageState createState() => _EditMemoryPageState();
}

class _EditMemoryPageState extends State<EditMemoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izmijenite uspomenu'),
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
                            const Text('Uklonite naslovnu fotografiju'),
                          ],
                        ),
                        value: 'remove-cover-photo',
                        onTap: () {},
                      ),
                    ],
                    child: (widget.data['coverPhotoUrl'] == null)
                        ? Container(
                            width: double.infinity,
                            height: 150.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.r),
                              color: backgroundColor,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                FeatherIcons.image,
                                size: 50.w,
                              ),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            height: 150.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.r),
                              color: backgroundColor,
                              image: DecorationImage(
                                image:
                                    NetworkImage(widget.data['coverPhotoUrl']),
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
                      const Text('Naslov'),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(
                          color: lightColor,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'npr. "Porodična večera", ...',
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      const Text('Kolekcija'),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.w,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<dynamic>(
                              borderRadius: BorderRadius.circular(7.r),
                              dropdownColor: backgroundColor,
                              style: Theme.of(context).textTheme.bodyText2,
                              hint: Text(
                                'Opšte (Nema kolekcije)',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  child: Text('Naslov 1'),
                                  value: 3,
                                ),
                                DropdownMenuItem(
                                  child: Text('Naslov 1'),
                                  value: 3,
                                ),
                                DropdownMenuItem(
                                  child: Text('Naslov 1'),
                                  value: 3,
                                ),
                                DropdownMenuItem(
                                  child: Text('Naslov 1'),
                                  value: 3,
                                ),
                                DropdownMenuItem(
                                  child: Text('Naslov 1'),
                                  value: 3,
                                ),
                              ],
                              onChanged: (index) {},
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      const Text('Uspomena/Priča'),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 5,
                        maxLines: 5,
                        style: const TextStyle(
                          color: lightColor,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'npr. Dragi dnevniče ...',
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
