import 'package:easypg/screens/widgets/empty_widget.dart';
import 'package:easypg/services/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/widgets/property_card.dart';
import 'package:easypg/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BookmarksPage extends StatefulWidget {
  final bool? isPurchased;
  const BookmarksPage({super.key, this.isPurchased});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  late final String emptyScreenMessage;
  @override
  void initState() {
    emptyScreenMessage = widget.isPurchased == null
        ? "Add Properties to Bookmark"
        : "Purchase Contact Info of the Properties";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) {
        return RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async => Future.delayed(Duration(milliseconds: 200)).whenComplete(
            () => setState(() {}),
          ),
          backgroundColor: myOrangeSecondary,
          color: myOrange,
          strokeWidth: 2.5.w,
          child: FutureBuilder(
            future: ApiHandler.instance.getPropertiesById(widget.isPurchased),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: myOrange,
                ));
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return EmptyScreen(
                  message: emptyScreenMessage,
                );
              }
              List<Property> properties = snapshot.requireData;
              return snapshot.requireData.isEmpty
                  ? EmptyScreen(
                      message: emptyScreenMessage,
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) =>
                          PropertyCard(property: properties[index], topWidget: 'bookmark'),
                      itemCount: properties.length,
                    );
            },
          ),
        );
      },
    );
  }
}
