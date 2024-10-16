import 'package:easypg/utils/app_keys.dart';

class Property {
  String id = '';
  String name = '';
  String position = '';
  String motive = '';
  String propertyType = '';
  String streetAddress = '';
  String pinCode = '';
  String city = '';
  String state = '';
  String bhk = '';
  String bathroom = '';
  String furniture = '';
  String rent = '';
  String deposit = '';
  List<String> amenities = [];
  List<String> photos = [];
  bool status = false;
  DateTime createdAt = DateTime.now();
  String uploaderId = '';
  List<String> tags = [];

  Property.required({
    required this.name,
    required this.position,
    required this.motive,
    required this.propertyType,
    required this.streetAddress,
    required this.pinCode,
    required this.city,
    required this.state,
    required this.bhk,
    required this.bathroom,
    required this.furniture,
    required this.rent,
    required this.deposit,
    required this.amenities,
    required this.photos,
    required this.createdAt,
    required this.status,
    required this.uploaderId,
  });

  factory Property.empty() => Property.required(
      name: '',
      position: '',
      motive: '',
      propertyType: '',
      streetAddress: '',
      pinCode: '',
      city: '',
      state: '',
      bhk: '',
      bathroom: '',
      furniture: '',
      rent: '',
      deposit: '',
      amenities: [],
      photos: [],
      createdAt: DateTime.now(),
      status: false,
      uploaderId: '');

  factory Property.fromJson(Map<String, dynamic> json, id) {
    return Property.required(
        name: json[AppKeys.nameKey],
        position: json[AppKeys.positionKey],
        motive: json[AppKeys.motiveKey],
        propertyType: json[AppKeys.propertyTypeKey],
        streetAddress: json[AppKeys.streetAddressKey],
        pinCode: json[AppKeys.pinCodeKey],
        city: json[AppKeys.cityKey],
        state: json[AppKeys.stateKey],
        bhk: json[AppKeys.bhkKey],
        bathroom: json[AppKeys.bathroomsKey],
        furniture: json[AppKeys.furnitureKey],
        rent: json[AppKeys.rentKey],
        deposit: json[AppKeys.depositKey],
        amenities: List.generate(
          json[AppKeys.amenitiesKey].length,
          (index) => json[AppKeys.amenitiesKey][index],
        ),
        photos: List.generate(
          json[AppKeys.photosKey].length,
          (index) => json[AppKeys.photosKey][index],
        ),
        createdAt: json[AppKeys.createdAtKey].toDate(),
        status: json[AppKeys.statusKey],
        uploaderId: json[AppKeys.uploaderIdKey])
      ..id = id ?? ''
      ..tags = json[AppKeys.tagsKey] == null
          ? []
          : List.generate(
              json[AppKeys.tagsKey].length,
              (index) => json[AppKeys.tagsKey][index],
            );
  }

  Map<String, dynamic> toJson() => {
        AppKeys.nameKey: name,
        AppKeys.positionKey: position,
        AppKeys.motiveKey: motive,
        AppKeys.propertyTypeKey: propertyType,
        AppKeys.streetAddressKey: streetAddress,
        AppKeys.pinCodeKey: pinCode,
        AppKeys.cityKey: city,
        AppKeys.stateKey: state,
        AppKeys.bhkKey: bhk,
        AppKeys.bathroomsKey: bathroom,
        AppKeys.furnitureKey: furniture,
        AppKeys.rentKey: rent,
        AppKeys.depositKey: deposit,
        AppKeys.amenitiesKey: amenities,
        AppKeys.photosKey: photos,
        AppKeys.createdAtKey: createdAt,
        AppKeys.statusKey: status,
        AppKeys.uploaderIdKey: uploaderId,
        AppKeys.tagsKey: generateTags()
      };
  String getAddress() => "$streetAddress, $city,$state - $pinCode";
  List<String> generateTags() =>
      [pinCode, furniture] +
      name.toLowerCase().split(' ').toList() +
      state.toLowerCase().split(' ').toList() +
      city.toLowerCase().split(" ").toList() +
      streetAddress.toLowerCase().split(" ");
}
