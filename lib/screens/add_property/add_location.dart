import 'package:easypg/screens/add_property/option_elevated_button.dart';
import 'package:easypg/screens/add_property/save_and_next_btn.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key, required this.handelPageChange});
  final Function handelPageChange;
  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  List<String> types = ['House', 'Pg/Hostel', 'Apartment', 'Duplex'];
  int _selection = 0;
  String streetAddress = '';
  String pinCode = '';
  String city = '';
  String state = '';

  _manageSave() {
    widget.handelPageChange();
  }

  _manageSelection(int index) => setState(()=>_selection=index);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        space(20),
        printHeading('Property Type'),
        space(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: OptionElevatedButton(isSelected: _selection == 0 , text: types[0], onPressed: () => _manageSelection(0),)),
            const SizedBox(width: 20,),
            Expanded(child: OptionElevatedButton(isSelected: _selection == 1 , text: types[1], onPressed: () => _manageSelection(1),))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: OptionElevatedButton(isSelected: _selection == 2 , text: types[2], onPressed: () => _manageSelection(2),)),
            const SizedBox(width: 20,),
            Expanded(child: OptionElevatedButton(isSelected: _selection == 3 , text: types[3], onPressed: () => _manageSelection(3),))
          ],
        ),
         space(20),
         TextField(decoration: const InputDecoration(hintText: 'Enter Street Address'),onChanged: (value) => setState(()=>streetAddress=value),),
        space(20),
        TextField(decoration: const InputDecoration(hintText: 'Enter Pin-Code'),onChanged: (value) => setState(()=>pinCode=value),),
        space(20),
        Row(children: [
          Expanded(child: TextField(decoration: const InputDecoration(hintText: 'Enter City'),onChanged: (value) => setState(()=>city=value),)),
          const SizedBox(width: 20,),
          Expanded(child: TextField(decoration: const InputDecoration(hintText: 'Enter State'),onChanged: (value) => setState(()=>state=value),)),
        ],),

        const Spacer(),
        SaveAndNextBtn(onPressed: _manageSave, msg: 'Save And Next'),
        space(20),
      ],
    );
  }
}
