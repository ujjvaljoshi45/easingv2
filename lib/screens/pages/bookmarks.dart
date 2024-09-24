import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/widgets/property_card.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiHandler.instance.getPropertiesById(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: myOrange,
          ));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(
            child: Text('No Data Found!'),
          );
        }
        List<Property> properties = snapshot.requireData;
        return snapshot.requireData.isEmpty
            ? const Center(
                child: Text('Empty!'),
              )
            : ListView.builder(
                itemBuilder: (context, index) => PropertyCard(
                  property: properties[index],
                  topWidget: {
                    'callback': () async {
                      await ApiHandler.instance.saveBookMark(properties[index].id,
                          !DataProvider.instance.getUser.bookmarks.contains(properties[index].id));
                      setState(() {});
                    },
                    'widget': Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),color: Colors.black,),

                      child: Icon(
                        !DataProvider.instance.getUser.bookmarks.contains(properties[index].id) ? Icons.bookmark_add_sharp : Icons.bookmark_remove_sharp,
                        color: Colors.white,
                      ),
                    )
                  },
                ),
                itemCount: properties.length,
              );
      },
    );
  }
}
