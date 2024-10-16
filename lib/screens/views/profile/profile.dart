import 'package:easypg/screens/views/profile/edit_profile.dart';
import 'package:easypg/screens/views/profile/logout_modal.dart';
import 'package:easypg/screens/views/profile/widget/action_items.dart';
import 'package:easypg/screens/views/profile/widget/add_money_dialog.dart';
import 'package:easypg/screens/views/profile/widget/profile_header.dart';
import 'package:easypg/screens/views/profile/widget/wallet_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/provider/auth_provider.dart';
import 'package:easypg/provider/data_provider.dart';


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
  Widget build(BuildContext context) => Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(user: user, onEdit: _showEditModal),
            Divider(height: 30.h),
            WalletSection(onAddMoney: _showAddMoneyDialog),
            Divider(height: 20.h),
            ActionItems(),
            const Spacer(),
            const Center(child: Text("Logo with Name goes here")),
          ],
        ),
      ),
    );

  AppBar _buildAppBar() => AppBar(
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
          icon: const Icon(Icons.logout),
        )
      ],
    );

  void _showEditModal(bool isNameEdit) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return isNameEdit ? const EditProfileNameBottomSheetModal() : const EditProfilePicture();
        },
      );

  Future<void> _showAddMoneyDialog() async => AddMoneyDialog.show(context);
}
