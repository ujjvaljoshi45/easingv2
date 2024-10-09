import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/screens/add_property/option_elevated_button.dart';
import 'package:easypg/screens/add_property/save_and_next_btn.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';

class OtherInformationPage extends StatefulWidget {
  const OtherInformationPage({super.key, required this.handelPageChange});
  final Function handelPageChange;
  @override
  State<OtherInformationPage> createState() => _OtherInformationPageState();
}

class _OtherInformationPageState extends State<OtherInformationPage> {
  int _currentBhkSelection = 0;
  int _currentFurnishedSelection = 0;
  int _bathrooms = 1;
  List<String> furnished = [
    'Un Furnished',
    'Semi Furnished',
    'Furnished',
  ];
  String rent = '';
  String deposit = '';

  @override
  void initState() {
    rent = AddPropertyProvider.instance.property.rent;
    deposit = AddPropertyProvider.instance.property.deposit;
    switch (AddPropertyProvider.instance.property.bhk) {
      case '2':
        _currentBhkSelection = 1;
        break;
      case '3':
        _currentBhkSelection = 2;
        break;
      case '3+':
        _currentBhkSelection = 3;
        break;
      default:
        _currentBhkSelection = 0;
        break;
    }
    switch (AddPropertyProvider.instance.property.bathroom) {
      case '2':
        _bathrooms = 2;
        break;
      case '3':
        _bathrooms = 3;
        break;
      default:
        _bathrooms = 1;
        break;
    }
    for (var element in furnished) {
      element == AddPropertyProvider.instance.property.furniture
          ? _currentFurnishedSelection = furnished.indexOf(element)
          : null;
    }
    AddPropertyProvider.instance.property.bathroom;
    super.initState();
  }

  _handelSave() {
    AddPropertyProvider.instance.setBHK(_currentBhkSelection.toString());
    AddPropertyProvider.instance.setBathroom(_bathrooms.toString());
    AddPropertyProvider.instance.setFurniture(furnished[_currentFurnishedSelection]);
    AddPropertyProvider.instance.setRent(rent);
    AddPropertyProvider.instance.setDeposit(deposit);
    _validate() ? widget.handelPageChange() : Fluttertoast.showToast(msg: 'Fill all the fields');
  }

  _validate() {
    return AddPropertyProvider.instance.property.bhk.isNotEmpty &&
        AddPropertyProvider.instance.property.bathroom.isNotEmpty &&
        AddPropertyProvider.instance.property.furniture.isNotEmpty &&
        AddPropertyProvider.instance.property.rent.isNotEmpty &&
        AddPropertyProvider.instance.property.deposit.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: getHeight(context) - kToolbarHeight.h - 20.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            space(20),
            printHeading('BHK /Bedroom(s)'),
            space(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < 4; i++)
                  OptionElevatedButton(
                      isSelected: _currentBhkSelection == i,
                      text: i == 3 ? '3+' : '${i + 1}',
                      onPressed: () => setState(() => _currentBhkSelection = i))
              ],
            ),
            space(20),
            printHeading('Bathrooms'),
            Align(
              alignment: Alignment.center,
              child: NumberPicker(
                minValue: 1,
                maxValue: 3,
                infiniteLoop: false,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2.w,
                    color: black,
                  ),
                ),
                value: _bathrooms,
                selectedTextStyle: montserrat.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) => setState(
                  () => _bathrooms = value,
                ),
                haptics: true,
                axis: Axis.horizontal,
              ),
            ),
            space(10),
            printHeading('Furniture Type'),
            space(10),
            Column(
              children: [
                for (int i = 0; i < furnished.length; i++)
                  Row(
                    children: [
                      Expanded(
                          child: OptionElevatedButton(
                        isSelected: _currentFurnishedSelection == i,
                        text: furnished[i],
                        onPressed: () => setState(() => _currentFurnishedSelection = i),
                      )),
                    ],
                  )
              ],
            ),
            space(20),
            printHeading('Expected Rent'),
            space(20),
            TextFormField(
              initialValue: AddPropertyProvider.instance.property.rent,
              onChanged: (value) => setState(() => rent = value),
              decoration: const InputDecoration(hintText: 'Enter Rent Here...'),
              keyboardType: TextInputType.number,
            ),
            space(20),
            TextFormField(
              initialValue: AddPropertyProvider.instance.property.deposit,
              onChanged: (value) => setState(() => deposit = value),
              decoration: const InputDecoration(hintText: 'Enter Deposit Here...'),
              keyboardType: TextInputType.number,
            ),
            const Spacer(),
            SaveAndNextBtn(onPressed: _handelSave, msg: 'Save And Next'),
            space(20),
          ],
        ),
      ),
    );
  }
}
