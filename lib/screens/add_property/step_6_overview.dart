import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/screens/widgets/property_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddPropertyProvider>(
      builder: (context, value, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PropertyCard(
                  property: value.property,
                  isOverview: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
