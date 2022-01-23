import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:memories/models/collection.dart';
import 'package:memories/models/memory.dart';
import 'package:memories/providers/collection_data_proivder.dart';
import 'package:memories/theme/colors.dart';
import 'package:provider/provider.dart';

class MemoryCard extends StatefulWidget {
  final MemoryModel? memory;
  const MemoryCard({Key? key, required this.memory}) : super(key: key);

  @override
  _MemoryCardState createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard> {
  @override
  Widget build(BuildContext context) {
    final List<CollectionModel?> _collections =
        Provider.of<CollectionDataProvoder>(context).collections;
    String? _collectionTitle;
    for (var collection in _collections) {
      if (collection!.id == widget.memory!.collectionId) {
        setState(() => _collectionTitle = collection.title);
      }
    }
    return GestureDetector(
      onTap: () {
        print(_collectionTitle);
        Navigator.pushNamed(context, '/memory', arguments: {
          'data': widget.memory!.toJson(),
          'collection_name': _collectionTitle,
        });
      },
      child: Container(
        width: double.infinity,
        height: 372.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(7.r),
        ),
        child: Column(
          children: [
            (widget.memory?.coverPhotoUrl == null)
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
                        image: NetworkImage(widget.memory!.coverPhotoUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 120.w,
                    child: Text(
                      widget.memory!.title,
                      style: Theme.of(context).textTheme.headline3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FeatherIcons.heart,
                      size: 25,
                      color: (widget.memory!.isFavorite == true)
                          ? primaryColor
                          : textColor,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FeatherIcons.calendar,
                        size: 25,
                        color: textColor,
                      ),
                      SizedBox(width: 5.w),
                      SizedBox(
                        width:
                            ((MediaQuery.of(context).size.width - 40.w) / 3) -
                                50.w,
                        child: Text(
                          DateFormat('dd-MM-yy').format(
                            DateTime.fromMicrosecondsSinceEpoch(
                                widget.memory!.createdAt),
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FeatherIcons.clock,
                        size: 25,
                        color: textColor,
                      ),
                      SizedBox(width: 5.w),
                      SizedBox(
                        width:
                            ((MediaQuery.of(context).size.width - 40.w) / 3) -
                                50.w,
                        child: Text(
                          DateFormat('HH:mm').format(
                            DateTime.fromMicrosecondsSinceEpoch(
                                widget.memory!.createdAt),
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        FeatherIcons.grid,
                        size: 25,
                        color: textColor,
                      ),
                      SizedBox(width: 5.w),
                      SizedBox(
                        width:
                            ((MediaQuery.of(context).size.width - 40.w) / 3) -
                                50.w,
                        child: Text(
                          _collectionTitle ?? 'Opšte',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: SizedBox(
                height: 108.h,
                child: Text(
                  widget.memory!.story,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 5,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
