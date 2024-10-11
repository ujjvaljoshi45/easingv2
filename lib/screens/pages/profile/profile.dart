import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/provider/auth_provider.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/pages/profile/aadhar_upload.dart';
import 'package:easypg/screens/pages/profile/edit_profile.dart';
import 'package:easypg/screens/pages/profile/logout_modal.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = 'ProfileScreen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AppUser user;
  @override
  void initState() {
    user = Provider.of<DataProvider>(context, listen: false).getUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.arrowtriangle_left_fill),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return LogoutConfirmationDialog(
                    onLogout: () {
                      AuthProvider.instance.logout(context);
                    },
                  );
                },
              ),
            icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
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
                        onTap: () => _showMyModal(false),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 3.w,
                                color: myOrangeSecondary,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  50.r,
                                ),
                              ),
                              color: myOrangeSecondary,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(2, 4),
                                  color: myOrange.withOpacity(0.7),
                                  blurRadius: 3.r,
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FaIcon(FontAwesomeIcons.camera, color: myOrange),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.displayName,
                          style: montserrat.copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.sp),
                        ),
                        IconButton(
                            onPressed: () => _showMyModal(true),
                            icon:  FaIcon(FontAwesomeIcons.penToSquare,color: myOrange,))
                      ],
                    ),
                    space(4),
                    Text(
                      user.phoneNo,
                      style: montserrat.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16.sp),
                    ),
                    space(10),
                  ],
                ),
              ],
            ),
            Divider(height: 30.h),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text("Aadhar Verification"),
              subtitle: Text(user.isAadharVerified ? "Verified" : "Not Verified",
                  style: montserrat.copyWith(
                      color: user.isAadharVerified ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AadharUploadPage(),
                ));
              },
            ),
            Divider(height: 20.h),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.clockRotateLeft),
              title: const Text("Payment History"),
              subtitle: const Text("View your past payments and manage upcoming ones."),
              onTap: () {
                // Navigate to payment history page
              },
            ),
            Divider(height: 20.h),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.bell),
              title: const Text("Notifications"),
              subtitle: const Text("Manage your notification preferences."),
              onTap: () {
                // Navigate to notification settings
              },
            ),
            Divider(height: 20.h),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.handsHelping),
              title: const Text("Contact Support"),
              onTap: () {
                // Navigate to support page
              },
            ),
            const Spacer(),
            const Center(child: Text("Logo with Name goes here")),
          ],
        ),
      ),
    );
  }

  void _showMyModal(bool isNameEdit) => showModalBottomSheet(
        elevation: 1,
        enableDrag: true,
        showDragHandle: true,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return isNameEdit ? const EditProfileNameBottomSheetModal() : const EditProfilePicture();
        },
      );
}
