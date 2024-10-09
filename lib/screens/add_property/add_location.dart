import 'package:csc_picker/csc_picker.dart';
import 'package:easypg/model/prediction.dart';
import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/screens/add_property/option_elevated_button.dart';
import 'package:easypg/screens/add_property/save_and_next_btn.dart';
import 'package:easypg/services/api_manager.dart';
import 'package:easypg/utils/tools.dart';
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
  List<String> types = ['House', 'Pg/Hostel', 'Apartment', 'Duplex'];
  int _selection = 0;
  String propertyName = '';
  String streetAddress = '';
  String pinCode = '';
  String city = '';
  String state = '';

  _manageSave() {
    AddPropertyProvider.instance.setName(propertyName);
    AddPropertyProvider.instance.setPropertyType(types[_selection]);
    AddPropertyProvider.instance.setStreetAddress(streetAddress);
    AddPropertyProvider.instance.setPinCode(pinCode);
    AddPropertyProvider.instance.setCity(city);
    AddPropertyProvider.instance.setState(state);
    _validate() ? widget.handelPageChange() : Fluttertoast.showToast(msg: 'Fill all the fields');
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

  _manageSelection(int index) => setState(() => _selection = index);
  @override
  void initState() {
    _selection = types.indexOf(AddPropertyProvider.instance.property.propertyType);
    _selection < 0 ? _selection = 0 : null;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: OptionElevatedButton(
                  isSelected: _selection == 0,
                  text: types[0],
                  onPressed: () => _manageSelection(0),
                )),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                    child: OptionElevatedButton(
                  isSelected: _selection == 1,
                  text: types[1],
                  onPressed: () => _manageSelection(1),
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: OptionElevatedButton(
                  isSelected: _selection == 2,
                  text: types[2],
                  onPressed: () => _manageSelection(2),
                )),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  child: OptionElevatedButton(
                    isSelected: _selection == 3,
                    text: types[3],
                    onPressed: () => _manageSelection(3),
                  ),
                ),
              ],
            ),
            space(20),
            TextFormField(
              initialValue: AddPropertyProvider.instance.property.name,
              decoration: const InputDecoration(hintText: 'Enter Property Name'),
              onChanged: (value) => setState(() => propertyName = value),
            ),
            space(20),
            TextFormField(
              initialValue: AddPropertyProvider.instance.property.streetAddress,
              decoration: const InputDecoration(hintText: 'Enter Street Address'),
              onChanged: (value) => setState(() => streetAddress = value),
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
              onStateChanged: (value) => setState(() => state = value ?? state),
              onCityChanged: (value) => setState(() => city = value ?? city),
              currentCity: city,
              currentState: state,
            ),
            if (city.length > 3)
              FutureBuilder(
                future: ApiManager.instance.get('https://api.postalpincode.in/postoffice/$city'),
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

                  List<PostOffice> postOffices =
                      PostOffice.parseResponse(snapshot.requireData.data.first, state);
                  logEvent('len: ${postOffices.length}');

                  try {
                    return DropdownButtonFormField(
                      // value: pinCode,
                      decoration: const InputDecoration(label: Text('Pin-Code')),
                      onChanged: (value) {
                        logEvent('value:$value');
                        pinCode = value ?? pinCode;
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
            const Spacer(),
            SaveAndNextBtn(onPressed: _manageSave, msg: 'Save And Next'),
            space(20),
          ],
        ),
      ),
    );
  }
}
