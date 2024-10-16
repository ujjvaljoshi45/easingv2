import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddPropertyProvider>(builder: (context, value, child) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Color(0xFF1E1E1E), // Card background color
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                      child: CarouselSlider.builder(
                        itemCount: value.property.photos.length,
                        itemBuilder: (context, index, realIndex) => Image.file(
                          File(value.property.photos[index]),
                          width: double.infinity.w,
                          fit: BoxFit.cover,
                        ), options: CarouselOptions(),
                        
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${value.property.bhk} BHK | ${value.property.bathroom} Bath',
                            style: montserrat.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${value.property.streetAddress}, ${value.property.city}, ${value.property.state} ${value.property.pinCode}',
                            style: montserrat.copyWith(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Rent: \$${value.property.rent} | Deposit: \$${value.property.deposit}',
                            style: montserrat.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Status: ${value.property.status ? 'Available' : 'Unavailable'}',
                            style: montserrat.copyWith(
                              fontSize: 14,
                              color: value.property.status ? Colors.green : Colors.red,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Amenities',
                            style: montserrat.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            children: value.property.amenities.map((amenity) {
                              return Chip(
                                label: Text(
                                  amenity,
                                  style: montserrat.copyWith(color: Colors.white),
                                ),
                                backgroundColor: Color(0xFFFF4B15), // Main color
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },);
  }
}
