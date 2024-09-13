import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/cache_manager.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/widgets/property_card.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              future: ApiHandler.instance.getProperties(),
              initialData: CacheManager.propertyCache,
              builder: (context, snapshot) {
                logEvent(snapshot.requireData.length);
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: myOrange,
                  ));
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('No Data Found!'),
                  );
                }

                if (!snapshot.hasData || snapshot.requireData.isEmpty) {
                  return const Center(
                    child: Text('No Data Found!'),
                  );
                }

                List<Property> properties = snapshot.requireData;
                CacheManager.propertyCache = properties;
                return snapshot.requireData.isEmpty
                    ? const Center(
                        child: Text('Empty!'),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) => PropertyCard(
                          property: properties[index],
                          topWidget: {
                            'callback': () async { await ApiHandler.instance.saveBookMark(properties[index].id,!DataProvider.instance.getUser.bookmarks.contains(properties[index].id)); setState(() {

                            });},
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
            ),
          ),
          space(10)
        ],
      ),
    );
  }
}
