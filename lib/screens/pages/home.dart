import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/property.dart';
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
    return  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          space(20),
          // const HouseCard(),
          ConstrainedBox(
              constraints: BoxConstraints(maxHeight: getHeight(context) - kBottomNavigationBarHeight - kToolbarHeight - getHeight(context)*0.2 - 10),
              child: FutureBuilder(future: ApiHandler.instance.getProperties(), builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: myOrange,));
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text('No Data Found!'),);
                }
                List<Property> properties = snapshot.requireData;
                return snapshot.requireData.isEmpty ? const Center(child: Text('Empty!'),) : ListView.builder(itemBuilder: (context, index) => PropertyCard(property: properties[index],),itemCount: properties.length,);
              },),),
          space(10)
        ],
      ),
    );
  }
}
