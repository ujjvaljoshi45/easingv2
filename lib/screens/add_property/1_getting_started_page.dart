import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/screens/add_property/widgets/option_elevated_button.dart';
import 'package:easypg/screens/add_property/widgets/save_and_next_btn.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';

class GettingStartedPage extends StatefulWidget {
  const GettingStartedPage({super.key, required this.handelPageChange});
  final Function handelPageChange;
  @override
  State<GettingStartedPage> createState() => _GettingStartedPageState();
}

class _GettingStartedPageState extends State<GettingStartedPage> {
  List<String> ownership = ['Owner', 'Agent', 'Builder'];

  List<String> motive = ['Rent / Lease', 'List as PG'];
  int selectedOption = 0;
  int selectedPurpose = 0;
  @override
  void initState() {
    selectedOption = ownership.indexOf(AddPropertyProvider.instance.property.position);
    selectedPurpose = motive.indexOf(AddPropertyProvider.instance.property.motive);

    selectedOption < 0 ? selectedOption = 0 : null;
    selectedPurpose < 0 ? selectedPurpose = 0 : null;
    super.initState();
  }

  _manageSave() {
    AddPropertyProvider.instance.setPosition(ownership[selectedOption]);
    AddPropertyProvider.instance.setMotive(motive[selectedPurpose]);
    // Save and then call
    widget.handelPageChange();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          space(20),
          printHeading('You Are'),
          space(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OptionElevatedButton(
                isSelected: selectedOption == 0,
                text: ownership[0],
                onPressed: () => setState(() => selectedOption = 0),
              ),
              OptionElevatedButton(
                isSelected: selectedOption == 1,
                text: ownership[1],
                onPressed: () => setState(() => selectedOption = 1),
              ),
              OptionElevatedButton(
                isSelected: selectedOption == 2,
                text: ownership[2],
                onPressed: () => setState(() => selectedOption = 2),
              ),
            ],
          ),
          space(20),
          printHeading('You Are Here To'),
          space(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OptionElevatedButton(
                isSelected: selectedPurpose == 0,
                text: motive[0],
                onPressed: () => setState(() => selectedPurpose = 0),
              ),
              OptionElevatedButton(
                isSelected: selectedPurpose == 1,
                text: motive[1],
                onPressed: () => setState(() => selectedPurpose = 1),
              ),
            ],
          ),
          const Spacer(),
          SaveAndNextBtn(onPressed: _manageSave, msg: 'Save And Next'),
          space(20),
        ],
      ),
    );
  }
}
