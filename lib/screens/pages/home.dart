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
          const HouseCard(),
        ],
      ),
    );
  }
}

class HouseCard extends StatelessWidget {
  const HouseCard({super.key});


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
                child: Image.asset(
                  'assets/demo1.png', // Replace with your image asset
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
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
                    'House',
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
                  'Dream House',
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
                      'New Satellite Road, Ahmedabad',
                        style: montserrat.copyWith(fontSize: 14, color: secondaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('₹ 9500', style: montserrat.copyWith(fontSize: 17,fontWeight: FontWeight.w600),),Text(' /Month',style: montserrat.copyWith(fontSize: 13,fontWeight: FontWeight.w600,color: secondaryColor),)
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
