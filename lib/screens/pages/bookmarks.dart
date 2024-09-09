import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/screens/widgets/property_card.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: 'Bookmarks',
              style:
                  montserrat.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: myOrange),
            ),
          ])),
          space(20),
          // const HouseCard(),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: getHeight(context) -
                    kBottomNavigationBarHeight -
                    kToolbarHeight -
                    getHeight(context) * 0.2 -
                    10),
            child: FutureBuilder(
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
                return snapshot.requireData.isEmpty ? const Center(child: Text('Empty!'),) : ListView.builder(
                  itemBuilder: (context, index) => PropertyCard(
                    property: properties[index],
                  ),
                  itemCount: properties.length,
                );
              },
            ),
          ),
          space(10)
        ],
      ),
    );
  }
}
