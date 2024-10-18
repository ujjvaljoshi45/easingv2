import 'package:easypg/screens/views/bookmarks.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PurchasedProperties extends StatelessWidget {
  const PurchasedProperties({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            CupertinoIcons.arrowtriangle_left_fill,
            color: getOnPrimary(context),
          ),
        ),
        title: Text("My Purchases",
            style: montserrat.copyWith(color: getOnPrimary(context), fontWeight: FontWeight.bold)),
        backgroundColor: getPrimary(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: BookmarksPage(
          isPurchased: true,
        ),
      ),
    );
  }
}
