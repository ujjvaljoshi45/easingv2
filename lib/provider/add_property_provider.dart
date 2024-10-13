import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/add_property/1_getting_started_page.dart';
import 'package:easypg/screens/add_property/2_add_location.dart';
import 'package:easypg/screens/add_property/3_other_information.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';

class AddPropertyProvider extends ChangeNotifier {
  AddPropertyProvider._();
  static final AddPropertyProvider instance = AddPropertyProvider._();
  Property property = Property.empty();

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

  Map<String, bool> myAmenities = {
    "Breakfast": false,
    "Lunch": false,
    "Dinner": false,
    "Drinking Water": false,
    "AC": false,
    "Laundry": false,
    "Cleaning": false
  };

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
  void setAmenities(List<String> lis) => property.amenities = lis.where((element) => element.isNotEmpty,).toList();
  void setPhotos(List<String> lis) => property.photos.addAll(lis);
  Future<void> save() async {
    property.uploaderId = DataProvider.instance.getUser.uid;
    int time = DateTime.now().millisecondsSinceEpoch;
    logEvent(property.toJson());
    List<String> urls = await ApiHandler.instance.saveImages(property.photos, time);
    property.photos = urls;
    property.id = time.toString();
    await ApiHandler.instance.saveProperty(property);
  }

  void clear() => property = Property.empty();
}
