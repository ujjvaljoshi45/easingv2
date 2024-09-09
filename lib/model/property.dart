class Property {
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
  DateTime createdAt = DateTime.now();

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
  });

  factory Property.empty() => Property.required(name: '' ,position: '', motive: '', propertyType: '', streetAddress: '', pinCode: '', city: '', state: '', bhk: '', bathroom: '', furniture: '', rent: '', deposit: '', amenities: [], photos: [], createdAt: DateTime.now());

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property.required(
      name: json[nameKey],
        position: json[positionKey],
        motive: json[motiveKey],
        propertyType: json[propertyTypeKey],
        streetAddress: json[streetAddressKey],
        pinCode: json[pinCodeKey],
        city: json[cityKey],
        state: json[stateKey],
        bhk: json[bhkKey],
        bathroom: json[bathroomsKey],
        furniture: json[furnitureKey],
        rent: json[rentKey],
        deposit: json[depositKey],
        amenities: List.generate(
          json[amenitiesKey].length,
          (index) => json[amenitiesKey][index],
        ),
        photos: List.generate(
          json[photosKey].length,
          (index) => json[photosKey][index],
        ),
        createdAt: json[createdAtKey].toDate());
  }

  Map<String, dynamic> toJson() => {
    nameKey:name,
        positionKey: position,
        motiveKey: motive,
        propertyTypeKey: propertyType,
        streetAddressKey: streetAddress,
        pinCodeKey: pinCode,
        cityKey: city,
        stateKey: state,
        bhkKey: bhk,
        bathroomsKey: bathroom,
        furnitureKey: furniture,
        rentKey: rent,
        depositKey: deposit,
        amenitiesKey: amenities,
        photosKey: photos,
        createdAtKey: createdAt,
      };
}

String positionKey = 'position';
String motiveKey = 'motive';
String propertyTypeKey = 'property_type';
String streetAddressKey = 'street_address';
String pinCodeKey = 'pin_code';
String cityKey = 'city';
String stateKey = 'state';
String bhkKey = 'bhk';
String bathroomsKey = 'bathrooms';
String furnitureKey = 'furniture';
String rentKey = 'rent';
String depositKey = 'deposit';
String amenitiesKey = 'amenities';
String photosKey = 'photos';
String createdAtKey = 'created_at';
String nameKey = 'name';
