import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/screens/add_property/widgets/save_and_next_btn.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdditionInformationPage extends StatefulWidget {
  final Function handelPageChange;
  const AdditionInformationPage({super.key, required this.handelPageChange});

  @override
  State<AdditionInformationPage> createState() => _AdditionInformationPageState();
}

class _AdditionInformationPageState extends State<AdditionInformationPage> {
  // Map<String, bool> myAmenities = {
  //   "Breakfast": false,
  //   "Lunch": false,
  //   "Dinner": false,
  //   "Drinking Water": false,
  //   "AC": false,
  //   "Laundry": false,
  //   "Cleaning": false
  // };
  // List<bool> status = List.generate(10, (index) => false,);
  @override
  void initState() {
    for (String key in AddPropertyProvider.instance.property.amenities) {
      // myAmenities[key] = true;
    }

    super.initState();
  }

  _manageSave() {
    // AddPropertyProvider.instance.setAmenities(List.generate(
    //   myAmenities.length,
    //   (index) =>
    //       myAmenities[myAmenities.keys.toList()[index]]! ? myAmenities.keys.toList()[index] : '',
    // ));
    widget.handelPageChange();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          space(10),
          for (int i = 0; i < AddPropertyProvider.instance.myAmenities.length; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AddPropertyProvider.instance.myAmenities.keys.toList()[i],
                  style: montserrat.copyWith(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                Checkbox(
                  value:AddPropertyProvider.instance. myAmenities[AddPropertyProvider.instance.myAmenities.keys.toList()[i]],
                  onChanged: (value) => setState(() => AddPropertyProvider.instance.myAmenities[AddPropertyProvider.instance.myAmenities.keys.toList()[i]] =
                      value ??AddPropertyProvider.instance.myAmenities[AddPropertyProvider.instance.myAmenities.keys.toList()[i]]!),
                ),
              ],
            ),
          space(20),
          const TextField(
            decoration: InputDecoration(hintText: 'Other...'),
          ),
          const Spacer(),
          SaveAndNextBtn(onPressed: _manageSave, msg: 'Save And Next'),
          space(20),
        ],
      ),
    );
  }
}
