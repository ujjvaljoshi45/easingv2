import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = 'ProfileScreen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppUser user = DataProvider.instance.getUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.arrowtriangle_left_fill),
        ),
      ),
      body: SizedBox(
        height: getHeight(context) - kToolbarHeight,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DottedBorder(
                  borderType: BorderType.Circle,
                  child: CircleAvatar(
                    radius: getWidth(context) * 0.12,
                    backgroundImage: DataProvider.instance.getUser.profileUrl.isEmpty
                        ? const AssetImage('assets/user_icon.png')
                        : CachedNetworkImageProvider(
                            DataProvider.instance.getUser.profileUrl,
                          ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: user.displayName,
                      style: montserrat.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    TextSpan(
                      text: '\n${user.phoneNo}',
                      style: montserrat.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  ],),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
