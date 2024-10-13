import 'package:csc_picker/csc_picker.dart';
import 'package:easypg/model/prediction.dart';
import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/screens/add_property/widgets/option_elevated_button.dart';
import 'package:easypg/screens/add_property/widgets/save_and_next_btn.dart';
import 'package:easypg/services/api_manager.dart';
import 'package:easypg/utils/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key, required this.handelPageChange});
  final Function handelPageChange;
  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  String propertyName = '';
  String streetAddress = '';
  String pinCode = '';
  String city = '';
  String state = '';

  _manageSave() {
    AddPropertyProvider.instance.setName(propertyName);
    // AddPropertyProvider.instance.setPropertyType(types[propertyTypeSelection]);
    AddPropertyProvider.instance.setStreetAddress(streetAddress);
    AddPropertyProvider.instance.setPinCode(pinCode);
    AddPropertyProvider.instance.setCity(city);
    AddPropertyProvider.instance.setState(state);
    _validate()
        ? widget.handelPageChange()
        : Fluttertoast.showToast(msg: 'Fill all the fields');
  }

  _validate() {
    logEvent(AddPropertyProvider.instance.property.toJson());
    return AddPropertyProvider.instance.property.name.isNotEmpty &&
        AddPropertyProvider.instance.property.propertyType.isNotEmpty &&
        AddPropertyProvider.instance.property.streetAddress.isNotEmpty &&
        AddPropertyProvider.instance.property.pinCode.isNotEmpty &&
        AddPropertyProvider.instance.property.city.isNotEmpty &&
        AddPropertyProvider.instance.property.state.isNotEmpty;
  }

  // _manageSelection(int index) => setState(() => propertyTypeSelection = index);
  @override
  void initState() {
    // propertyTypeSelection = types.indexOf(AddPropertyProvider.instance.property.propertyType);
    // propertyTypeSelection < 0 ? propertyTypeSelection = 0 : null;
    propertyName = AddPropertyProvider.instance.property.name;
    streetAddress = AddPropertyProvider.instance.property.streetAddress;
    pinCode = AddPropertyProvider.instance.property.pinCode;
    state = AddPropertyProvider.instance.property.state;
    city = AddPropertyProvider.instance.property.city;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: getHeight(context) - kToolbarHeight.h - 40.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            space(20),
            printHeading('Property Type'),
            space(20),
            Center(
              child: Wrap(
                runSpacing: 1,
                children: [
                  for (int index = 0; index < 4; index++)
                  SizedBox(
                    width: getWidth(context) * 0.45,
                    child: OptionElevatedButton(
                      isSelected:
                      AddPropertyProvider.instance.propertyTypeSelection == index,
                      text: AddPropertyProvider.instance.types[index],
                      onPressed: () {
                        AddPropertyProvider.instance.propertyTypeSelection = index;
                        AddPropertyProvider.instance.setPropertyType(AddPropertyProvider.instance.types[AddPropertyProvider.instance.propertyTypeSelection]);
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Expanded(
            //         child: OptionElevatedButton(
            //       isSelected:
            //           AddPropertyProvider.instance.propertyTypeSelection == 0,
            //       text: AddPropertyProvider.instance.types[0],
            //       onPressed: () =>
            //           AddPropertyProvider.instance.propertyTypeSelection = 0,
            //     )),
            //     SizedBox(
            //       width: 20.w,
            //     ),
            //     Expanded(
            //         child: OptionElevatedButton(
            //       isSelected:
            //           AddPropertyProvider.instance.propertyTypeSelection == 1,
            //       text: AddPropertyProvider.instance.types[1],
            //       onPressed: () =>
            //           AddPropertyProvider.instance.propertyTypeSelection = 1,
            //     ))
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Expanded(
            //         child: OptionElevatedButton(
            //       isSelected:
            //           AddPropertyProvider.instance.propertyTypeSelection == 2,
            //       text: AddPropertyProvider.instance.types[2],
            //       onPressed: () =>
            //           AddPropertyProvider.instance.propertyTypeSelection = 2,
            //     )),
            //     SizedBox(
            //       width: 20.w,
            //     ),
            //     Expanded(
            //       child: OptionElevatedButton(
            //         isSelected:
            //             AddPropertyProvider.instance.propertyTypeSelection == 3,
            //         text: AddPropertyProvider.instance.types[3],
            //         onPressed: () =>
            //             AddPropertyProvider.instance.propertyTypeSelection = 3,
            //       ),
            //     ),
            //   ],
            // ),
            space(20),
            TextFormField(
              initialValue: AddPropertyProvider.instance.property.name,
              decoration:
                  const InputDecoration(hintText: 'Enter Property Name'),
              onChanged: (value) => AddPropertyProvider.instance.setName(value),
            ),
            space(20),
            TextFormField(
              initialValue: AddPropertyProvider.instance.property.streetAddress,
              decoration:
                  const InputDecoration(hintText: 'Enter Street Address'),
              onChanged: (value) => AddPropertyProvider.instance.setStreetAddress(value),
            ),
            space(20),
            CSCPicker(
              showCities: true,
              showStates: true,
              disableCountry: true,
              defaultCountry: CscCountry.India,
              stateDropdownLabel: 'State',
              cityDropdownLabel: 'City',
              flagState: CountryFlag.DISABLE,
              currentCountry: CscCountry.India.name,
              onStateChanged: (value) => setState(() => AddPropertyProvider.instance.property.state = value ?? AddPropertyProvider.instance.property.state),
              onCityChanged: (value) => setState(() => AddPropertyProvider.instance.property.city = value ?? AddPropertyProvider.instance.property.city),
              currentCity: AddPropertyProvider.instance.property.city,
              currentState: AddPropertyProvider.instance.property.state,
            ),
            if (AddPropertyProvider.instance.property.city.length > 3)
              FutureBuilder(
                future: ApiManager.instance
                    .get('https://api.postalpincode.in/postoffice/${AddPropertyProvider.instance.property.city}'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return TextFormField(
                      enabled: false,
                      initialValue: 'Searching...',
                    );
                  }
                  if (snapshot.hasError) {
                    return TextFormField(
                      enabled: false,
                      initialValue: 'Enable To Get Pin Code',
                    );
                  }

                  List<PostOffice> postOffices = PostOffice.parseResponse(
                      snapshot.requireData.data.first, AddPropertyProvider.instance.property.state);
                  logEvent('len: ${postOffices.length}');

                  try {
                    return DropdownButtonFormField(
                      // value: pinCode,
                      decoration:
                          const InputDecoration(label: Text('Pin-Code')),
                      onChanged: (value) {
                        logEvent('value:$value');
                        AddPropertyProvider.instance.property.pinCode = value ?? AddPropertyProvider.instance.property.pinCode;
                      },
                      items: [
                        for (int i = 0; i < postOffices.length; i++)
                          DropdownMenuItem(
                            value: postOffices[i].pincode,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(postOffices[i].pincode),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  postOffices[i].name,
                                  softWrap: true,
                                )
                              ],
                            ),
                          ),
                      ],
                    );
                  } catch (e, stackTrace) {
                    logError('-_-', e, stackTrace);
                    return Text('ERROR: $e');
                  }
                },
              ),

          ],
        ),
      ),
    );
  }
}
