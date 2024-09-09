import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';

class AddPropertyProvider extends ChangeNotifier {
  AddPropertyProvider._();
  static final AddPropertyProvider instance = AddPropertyProvider._();
  Property property = Property.empty();

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
  void setAmenities(List<String> lis) => property.amenities = lis;
  void setPhotos(List<String> lis) => property.photos.addAll(lis);
  Future<void> save() async {
    logEvent(property.toJson());
    List<String> urls = await ApiHandler.instance.saveImages(property.photos);
    property.photos = urls;
    ApiHandler.instance.saveProperty(property);
  }
  void clear() => property = Property.empty();
}
