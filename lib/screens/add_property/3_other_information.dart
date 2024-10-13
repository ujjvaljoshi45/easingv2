import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/screens/add_property/widgets/option_elevated_button.dart';
import 'package:easypg/screens/add_property/widgets/save_and_next_btn.dart';
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

  String rent = '';
  String deposit = '';

  @override
  void initState() {
    rent = AddPropertyProvider.instance.property.rent;
    deposit = AddPropertyProvider.instance.property.deposit;
    // switch (AddPropertyProvider.instance.property.bhk) {
    //   case '2':
    //     currentBhkSelection = 1;
    //     break;
    //   case '3':
    //     currentBhkSelection = 2;
    //     break;
    //   case '3+':
    //     currentBhkSelection = 3;
    //     break;
    //   default:
    //     currentBhkSelection = 0;
    //     break;
    // }
    // switch (AddPropertyProvider.instance.property.bathroom) {
    //   case '2':
    //     bathrooms = 2;
    //     break;
    //   case '3':
    //     bathrooms = 3;
    //     break;
    //   default:
    //     bathrooms = 1;
    //     break;
    // }
    // for (var element in furnished) {
    //   element == AddPropertyProvider.instance.property.furniture
    //       ? currentFurnishedSelection = furnished.indexOf(element)
    //       : null;
    // }
    // AddPropertyProvider.instance.property.bathroom;
    super.initState();
  }

  _handelSave() {
    // AddPropertyProvider.instance.setBHK(currentBhkSelection.toString());
    // AddPropertyProvider.instance.setBathroom(bathrooms.toString());
    // AddPropertyProvider.instance.setFurniture(furnished[currentFurnishedSelection]);
    // AddPropertyProvider.instance.setRent(rent);
    // AddPropertyProvider.instance.setDeposit(deposit);
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
                      isSelected: AddPropertyProvider.instance.currentBhkSelection == i,
                      text: i == 3 ? '3+' : '${i + 1}',
                      onPressed: () {
                        setState(() => AddPropertyProvider.instance.currentBhkSelection = i);
                        AddPropertyProvider.instance.setBHK(AddPropertyProvider.instance.currentBhkSelection.toString());
                      })
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
                value: AddPropertyProvider.instance.bathrooms,
                selectedTextStyle: montserrat.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) {
                  setState(
                  () => AddPropertyProvider.instance.bathrooms = value,
                );
                  AddPropertyProvider.instance.setBathroom(AddPropertyProvider.instance.bathrooms.toString());
                },
                haptics: true,
                axis: Axis.horizontal,
              ),
            ),
            space(10),
            printHeading('Furniture Type'),
            space(10),
            Column(
              children: [
                for (int i = 0; i < AddPropertyProvider.instance.furnished.length; i++)
                  Row(
                    children: [
                      Expanded(
                          child: OptionElevatedButton(
                        isSelected: AddPropertyProvider.instance.currentFurnishedSelection == i,
                        text: AddPropertyProvider.instance.furnished[i],
                        onPressed: () {
                          setState(() => AddPropertyProvider.instance.currentFurnishedSelection = i);
                          AddPropertyProvider.instance.setFurniture(AddPropertyProvider.instance.furnished[AddPropertyProvider.instance.currentFurnishedSelection]);
                        },
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
              onChanged: (value) => setState(() => AddPropertyProvider.instance.property.rent = value),
              decoration: const InputDecoration(hintText: 'Enter Rent Here...'),
              keyboardType: TextInputType.number,
            ),
            space(20),
            TextFormField(
              initialValue: AddPropertyProvider.instance.property.deposit,
              onChanged: (value) => setState(() => AddPropertyProvider.instance.property.deposit = value),
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
