import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/provider/auth_provider.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/views/profile/edit_profile.dart';
import 'package:easypg/screens/views/profile/logout_modal.dart';
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
                    AuthDataProvider.instance.logout(context);
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
            _buildProfileHeader(),
            Divider(height: 30.h),
            _buildWalletSection(),
            Divider(height: 20.h),
            _buildActionItems(),
            const Spacer(),
            const Center(child: Text("Logo with Name goes here")),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
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
                      Radius.circular(50.r),
                    ),
                    color: myOrangeSecondary,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(2, 4),
                        color: myOrange.withOpacity(0.7),
                        blurRadius: 3.r,
                      ),
                    ],
                  ),
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
                  icon: FaIcon(
                    FontAwesomeIcons.penToSquare,
                    color: myOrange,
                  ),
                ),
              ],
            ),
            space(4),
            Text(
              user.phoneNo,
              style: montserrat.copyWith(
                  color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWalletSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Wallet Balance",
          style: montserrat.copyWith(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "₹12",
              style: montserrat.copyWith(
                  color: myOrange, fontWeight: FontWeight.bold, fontSize: 24.sp),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: myOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _addMoneyDialog,
              child: Text(
                "Add Money",
                style: montserrat.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildActionItems() {
    return Column(
      children: [
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
          leading: const FaIcon(FontAwesomeIcons.solidBell),
          title: const Text("Notifications"),
          subtitle: const Text("Manage your notification preferences."),
          onTap: () {
            // Navigate to notification settings
          },
        ),
        Divider(height: 20.h),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.headset),
          title: const Text("Contact Support"),
          onTap: () {
            // Navigate to support page
          },
        ),
      ],
    );
  }

  void _addMoneyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Money"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Enter Amount",
              border: OutlineInputBorder(),
            ),
            onSubmitted: (amount) {
              // Handle the add money logic
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle the add money logic
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
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
