import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookmarkWidget extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  const BookmarkWidget({super.key, required this.isBookmarked, required this.onBookmarkToggle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onBookmarkToggle,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            color: Colors.black,
            backgroundBlendMode: BlendMode.overlay),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FaIcon(
              isBookmarked ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
