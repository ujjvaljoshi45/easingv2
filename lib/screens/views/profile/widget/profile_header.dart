import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeader extends StatelessWidget {
  final AppUser user;
  final Function(bool) onEdit;

  const ProfileHeader({super.key, required this.user, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileImage(context),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  user.displayName,
                  style: montserrat.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                IconButton(
                  onPressed: () => onEdit(true),
                  icon: Icon(Icons.edit, color: myOrange),
                ),
              ],
            ),
            space(4),
            Text(
              user.phoneNo,
              style: montserrat.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Stack(
      children: [
        DottedBorder(
          borderType: BorderType.Circle,
          child: CircleAvatar(
            radius: getWidth(context) * 0.12.w,
            backgroundImage: user.profileUrl.isEmpty
                ? const AssetImage('assets/user_icon.png')
                : CachedNetworkImageProvider(user.profileUrl),
          ),
        ),
        Positioned(
          bottom: 1.h,
          right: 1.w,
          child: InkWell(
            onTap: () => onEdit(false),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 3.w, color: myOrangeSecondary),
                shape: BoxShape.circle,
                color: myOrangeSecondary,
                boxShadow: [BoxShadow(offset: const Offset(2, 4), color: myOrange.withOpacity(0.7), blurRadius: 3.r)],
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(Icons.camera_alt, color: myOrange),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
