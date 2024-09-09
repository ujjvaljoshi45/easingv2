import 'package:cached_network_image/cached_network_image.dart';
import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
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
          RichText(text: TextSpan(children: [
            TextSpan(text: 'Find Your',style: montserrat.copyWith(fontSize: 24,fontWeight: FontWeight.bold,color: black)),
            TextSpan(text: ' Dream', style: montserrat.copyWith(fontSize: 24,fontWeight: FontWeight.bold,color: myOrange),),
            TextSpan(text: '\nHome Today',style: montserrat.copyWith(fontSize: 24,fontWeight: FontWeight.bold,color: black)),
          ])),
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
                return ListView.builder(itemBuilder: (context, index) => HouseCard(property: properties[index],),itemCount: properties.length,);
              },),),
          space(10)
        ],
      ),
    );
  }
}

class HouseCard extends StatelessWidget {
  const HouseCard({super.key, required this.property});
  final Property property;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child:CachedNetworkImage(imageUrl: property.photos.first,height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,)
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: myOrangeSecondary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child:  Text(
                    property.propertyType,
                    style: montserrat.copyWith(
                      color: myOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                   property.name,
                  style: montserrat.copyWith(fontSize: 20,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                     Icon(
                      Icons.location_pin,
                      color: pinColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${property.streetAddress}, ${property.city}',
                        style: montserrat.copyWith(fontSize: 14, color: secondaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('₹ ${property.rent}', style: montserrat.copyWith(fontSize: 17,fontWeight: FontWeight.w600),),Text(' /Month',style: montserrat.copyWith(fontSize: 13,fontWeight: FontWeight.w600,color: secondaryColor),)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
