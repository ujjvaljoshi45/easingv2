import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/add_property/1_getting_started_page.dart';
import 'package:easypg/screens/add_property/2_add_location.dart';
import 'package:easypg/screens/add_property/3_other_information.dart';
import 'package:easypg/screens/add_property/4_amenities_information.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';

class AddPropertyProvider extends ChangeNotifier {
  AddPropertyProvider._();
  static final AddPropertyProvider instance = AddPropertyProvider._();
  Property property = Property.empty();

  final PageController pageController = PageController();
  int currentIndex = 0;
  final int totalLength = 4;
  final List<String> appBarTitle = [
    'Let’s get you started',
    'Property Location',
    'Relevant Information',
    'Additional Information',
    'Add Photos',
  ];

  /// For [GettingStartedPage]
  List<String> ownership = ['Owner', 'Agent', 'Builder'];
  List<String> motive = ['Rent / Lease', 'List as PG'];
  int selectedOption = 0;
  int selectedPurpose = 0;

  /// For [AddLocationPage]
  List<String> types = ['House', 'Pg/Hostel', 'Apartment', 'Duplex'];
  int propertyTypeSelection = 0;

  /// For [OtherInformationPage]
  int currentBhkSelection = 0;
  int currentFurnishedSelection = 0;
  int bathrooms = 1;
  List<String> furnished = [
    'Un Furnished',
    'Semi Furnished',
    'Furnished',
  ];

  /// For [AddAmenitiesPage]
  Map<String, bool> myAmenities = {
    "Breakfast": false,
    "Lunch": false,
    "Dinner": false,
    "Drinking Water": false,
    "AC": false,
    "Laundry": false,
    "Cleaning": false
  };


  handelPageChangeChange() {
    if (currentIndex < totalLength) {
      switch(currentIndex) {
        case 1: if (!stepOneValidation()) {showToast('Please Fill All the Fields', Colors.redAccent); return;}
        case 2: if (!stepThreeValidation()) {showToast('Please Fill All the Fields', Colors.redAccent); return;}
        case 5: if (!stepFiveValidation()) {showToast('Please Fill All the Fields', Colors.redAccent); return;}
      }
      currentIndex++;
      debugPrint("cIndex:$currentIndex");
      pageController.animateToPage(currentIndex,
          curve: Curves.linearToEaseOut,
          duration: const Duration(milliseconds: 100));
    } else {
      AddPropertyProvider.instance.setAmenities(List.generate(
        AddPropertyProvider.instance.myAmenities.length,
        (index) => AddPropertyProvider.instance.myAmenities[
                AddPropertyProvider.instance.myAmenities.keys.toList()[index]]!
            ? AddPropertyProvider.instance.myAmenities.keys.toList()[index]
            : '',
      ));
      logEvent(AddPropertyProvider.instance.property.toJson());
      showToast('end', null);
      return;
    }
  }

  manageBack(
    BuildContext context,
  ) {
    debugPrint("clicked : $currentIndex");
    if (currentIndex <= 0) {
      AddPropertyProvider.instance.clear();
      Navigator.pop(context);
    } else {
      currentIndex--;
      pageController.animateToPage(currentIndex,
          curve: Curves.linearToEaseOut,
          duration: const Duration(milliseconds: 250));
    }
  }

  void setPosition(String str) => property.position = str;
  void setMotive(String str) => property.motive = str;
  void setPropertyType(String str) => property.propertyType = str;
  void setName(String str) => property.name = str;
  void setStreetAddress(String str) => property.streetAddress = str;
  void setPinCode(String str) => property.pinCode = str;
  void setState(String str) => property.state = str;
  void setCity(String str) => property.city = str;
  void setBHK(String str) => property.bhk = str;
  void setBathroom(String str) => property.bathroom = str;
  void setFurniture(String str) => property.furniture = str;
  void setRent(String str) => property.rent = str;
  void setDeposit(String str) => property.deposit = str;
  void setAmenities(List<String> lis) => property.amenities = lis
      .where(
        (element) => element.isNotEmpty,
      )
      .toList();
  void setPhotos(List<String> lis) => property.photos.addAll(lis);

  Future<void> save() async {
    property.uploaderId = DataProvider.instance.getUser.uid;
    int time = DateTime.now().millisecondsSinceEpoch;
    logEvent(property.toJson());
    List<String> urls =
        await ApiHandler.instance.saveImages(property.photos, time);
    property.photos = urls;
    property.id = time.toString();
    await ApiHandler.instance.saveProperty(property);
  }

  bool stepOneValidation() => AddPropertyProvider.instance.property.name.isNotEmpty &&
        AddPropertyProvider.instance.property.propertyType.isNotEmpty &&
        AddPropertyProvider.instance.property.streetAddress.isNotEmpty &&
        AddPropertyProvider.instance.property.pinCode.isNotEmpty &&
        AddPropertyProvider.instance.property.city.isNotEmpty &&
        AddPropertyProvider.instance.property.state.isNotEmpty;

  bool stepThreeValidation() {
    logEvent("rent:${AddPropertyProvider.instance.property.rent}");
    return AddPropertyProvider.instance.property.bhk.isNotEmpty &&
        AddPropertyProvider.instance.property.bathroom.isNotEmpty &&
        AddPropertyProvider.instance.property.furniture.isNotEmpty &&
        AddPropertyProvider.instance.property.rent.isNotEmpty &&
        AddPropertyProvider.instance.property.deposit.isNotEmpty;
  }

  bool stepFiveValidation()  => AddPropertyProvider.instance.property.photos.length >= 4;

  void clear() {
    selectedPurpose = 0;selectedOption=0;currentIndex = 0;bathrooms = 1;
    for (var element in myAmenities.keys) {
      myAmenities[element] = false;
    }
    property = Property.empty();

  }
}
