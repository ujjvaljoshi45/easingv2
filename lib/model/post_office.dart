class PostOffice {
  String name;
  String? description;
  String branchType;
  String deliveryStatus;
  String circle;
  String district;
  String division;
  String region;
  String state;
  String country;
  String pincode;

  PostOffice({
    required this.name,
    this.description,
    required this.branchType,
    required this.deliveryStatus,
    required this.circle,
    required this.district,
    required this.division,
    required this.region,
    required this.state,
    required this.country,
    required this.pincode,
  });

  factory PostOffice.fromJson(Map<String, dynamic> json) {
    return PostOffice(
      name: json['Name'],
      description: json['Description'],
      branchType: json['BranchType'],
      deliveryStatus: json['DeliveryStatus'],
      circle: json['Circle'],
      district: json['District'],
      division: json['Division'],
      region: json['Region'],
      state: json['State'],
      country: json['Country'],
      pincode: json['Pincode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Description': description,
      'BranchType': branchType,
      'DeliveryStatus': deliveryStatus,
      'Circle': circle,
      'District': district,
      'Division': division,
      'Region': region,
      'State': state,
      'Country': country,
      'Pincode': pincode,
    };
  }

  static List<PostOffice> parseResponse(Map<String, dynamic> json, String state) {
    List<PostOffice> postOffices =
        (json['PostOffice'] as List).map((postOffice) => PostOffice.fromJson(postOffice)).toList();

    postOffices.removeWhere(
      (element) => element.state != state,
    );
    postOffices = removeDuplicatesByPincode(postOffices);
    return postOffices;
  }

  static List<PostOffice> removeDuplicatesByPincode(List<PostOffice> postOffices) {
    Set<String> seenPincodes = List.generate(
      postOffices.length,
      (index) => postOffices[index].pincode,
    ).toSet();
    return List.generate(
      seenPincodes.length,
      (index) => postOffices[postOffices.indexWhere(
        (element) => element.pincode == seenPincodes.elementAt(index),
      )],
    );
  }
}
