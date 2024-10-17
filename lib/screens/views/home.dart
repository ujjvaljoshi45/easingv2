import 'package:easypg/screens/widgets/empty_widget.dart';
import 'package:easypg/services/api_handler.dart';
import 'package:easypg/model/cache_manager.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/screens/widgets/property_card.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async => Future.delayed(Duration(milliseconds: 200)).whenComplete(() => setState(() {}),),
      backgroundColor: myOrangeSecondary,
      color: myOrange,
      strokeWidth: 2.5.w,
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
          if (snapshot.hasError || !snapshot.hasData || snapshot.requireData.isEmpty) {
            return const Center(
              child: EmptyScreen(message: "No Properties Found",),
            );
          }

          List<Property> properties = snapshot.requireData;
          CacheManager.propertyCache = properties;
          return snapshot.requireData.isEmpty
              ? const Center(
                  child: Text('Empty!'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      PropertyCard(property: properties[index], topWidget: 'bookmark'),
                  itemCount: properties.length,
                );
        },
      ),
    );
  }
}
