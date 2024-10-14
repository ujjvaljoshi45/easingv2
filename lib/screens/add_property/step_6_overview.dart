import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/utils/colors.dart';
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
    return Provider.of<AddPropertyProvider>(context, listen: true).isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: myOrange,
            ),
          )
        : Column(
            children: [
              Text("This is Overview Page"),
            ],
          );
  }
}
