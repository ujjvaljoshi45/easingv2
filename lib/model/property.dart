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
        createdAt: json[createdAtKey].toDate(),
        status: json[statusKey],
        uploaderId: json[uploaderIdKey])
      ..id = id ?? ''
      ..tags = json[tagsKey] == null ? [] : List.generate(
        json[tagsKey].length,
        (index) => json[tagsKey][index],
      );
  }

  Map<String, dynamic> toJson() => {
        nameKey: name,
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
        statusKey: status,
        uploaderIdKey: uploaderId,
        tagsKey: generateTags()
      };
  String getAddress() => "$streetAddress, $city,$state - $pinCode";
  List<String> generateTags() => [pinCode, furniture] +
      name.toLowerCase().split(' ').toList() +
      state.toLowerCase().split(' ').toList() +
      city.toLowerCase().split(" ").toList() +
      streetAddress.toLowerCase().split(" ");
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
String statusKey = 'status';
String uploaderIdKey = 'uploader_id';
String tagsKey = 'tags';
