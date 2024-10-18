import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/screens/add_property/widgets/option_elevated_button.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';

class GettingStartedPage extends StatefulWidget {
  const GettingStartedPage({super.key});

  @override
  State<GettingStartedPage> createState() => _GettingStartedPageState();
}

class _GettingStartedPageState extends State<GettingStartedPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        space(20),
        printHeading('You Are'),
        space(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < 3; i++)
              OptionElevatedButton(
                isSelected: AddPropertyProvider.instance.selectedOption == i,
                text: AddPropertyProvider.instance.ownership[i],
                onPressed: () {
                  setState(() => AddPropertyProvider.instance.selectedOption = i);
                  AddPropertyProvider.instance.setPosition(AddPropertyProvider
                      .instance.ownership[AddPropertyProvider.instance.selectedOption]);
                },
              ),
          ],
        ),
        space(20),
        printHeading('You Are Here To'),
        space(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < 2; i++)
              OptionElevatedButton(
                isSelected: AddPropertyProvider.instance.selectedPurpose == i,
                text: AddPropertyProvider.instance.motive[i],
                onPressed: () {
                  setState(() => AddPropertyProvider.instance.selectedPurpose = i);
                  AddPropertyProvider.instance.setMotive(AddPropertyProvider
                      .instance.motive[AddPropertyProvider.instance.selectedPurpose]);
                },
              ),
          ],
        ),
      ],
    );
  }
}
