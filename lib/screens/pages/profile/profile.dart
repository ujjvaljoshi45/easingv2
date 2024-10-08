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
                        radius: getWidth(context) * 0.12,
                        backgroundImage: user.profileUrl.isEmpty
                            ? const AssetImage('assets/user_icon.png')
                            : CachedNetworkImageProvider(user.profileUrl),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: InkWell(
                        onTap: () => _showMyModal(false),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: myOrangeSecondary,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  50,
                                ),
                              ),
                              color: myOrangeSecondary,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(2, 4),
                                  color: myOrange.withOpacity(0.7),
                                  blurRadius: 3,
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
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.displayName,
                          style: montserrat.copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        IconButton(
                            onPressed: () => _showMyModal(true),
                            icon:  FaIcon(FontAwesomeIcons.penToSquare,color: myOrange,))
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.phoneNo,
                      style: montserrat.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    // ElevatedButton.icon(
                    //   onPressed: _showEditProfileModal,
                    //   icon: const Icon(Icons.edit, size: 20),
                    //   label: const Text("Edit Profile"),
                    // ),
                  ],
                ),
              ],
            ),
            const Divider(height: 30),
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
            const Divider(height: 20),
            ListTile(
              leading: const Icon(Icons.payment_outlined),
              title: const Text("Payment History"),
              subtitle: const Text("View your past payments and manage upcoming ones."),
              onTap: () {
                // Navigate to payment history page
              },
            ),
            const Divider(height: 20),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text("Notifications"),
              subtitle: const Text("Manage your notification preferences."),
              onTap: () {
                // Navigate to notification settings
              },
            ),
            const Divider(height: 20),
            ListTile(
              leading: const Icon(Icons.support_agent_outlined),
              title: const Text("Contact Support"),
              onTap: () {
                // Navigate to support page
              },
            ),
            // const Spacer(),
            // ElevatedButton.icon(
            //   onPressed: () {
            //     // Navigate to help or support section
            //   },
            //   icon: const Icon(Icons.help_outline, size: 20),
            //   label: const Text("Help & Support"),
            //   style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blueAccent),
            // ),
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
