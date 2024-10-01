// class Prediction {
//   final String description;
//   final List<MatchedSubstring> matchedSubstrings;
//   final String placeId;
//   final String reference;
//   final StructuredFormatting structuredFormatting;
//   final List<Term> terms;
//   final List<String> types;
//
//   Prediction({
//     required this.description,
//     required this.matchedSubstrings,
//     required this.placeId,
//     required this.reference,
//     required this.structuredFormatting,
//     required this.terms,
//     required this.types,
//   });
//
//   factory Prediction.fromJson(Map<String, dynamic> json) {
//     return Prediction(
//       description: json['description'],
//       matchedSubstrings: (json['matched_substrings'] as List)
//           .map((e) => MatchedSubstring.fromJson(e))
//           .toList(),
//       placeId: json['place_id'],
//       reference: json['reference'],
//       structuredFormatting: StructuredFormatting.fromJson(json['structured_formatting']),
//       terms: (json['terms'] as List).map((e) => Term.fromJson(e)).toList(),
//       types: List<String>.from(json['types']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'description': description,
//       'matched_substrings': matchedSubstrings.map((e) => e.toJson()).toList(),
//       'place_id': placeId,
//       'reference': reference,
//       'structured_formatting': structuredFormatting.toJson(),
//       'terms': terms.map((e) => e.toJson()).toList(),
//       'types': types,
//     };
//   }
// }
//
// class MatchedSubstring {
//   final int length;
//   final int offset;
//
//   MatchedSubstring({
//     required this.length,
//     required this.offset,
//   });
//
//   factory MatchedSubstring.fromJson(Map<String, dynamic> json) {
//     return MatchedSubstring(
//       length: json['length'],
//       offset: json['offset'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'length': length,
//       'offset': offset,
//     };
//   }
// }
//
// class StructuredFormatting {
//   final String mainText;
//   final List<MatchedSubstring> mainTextMatchedSubstrings;
//   final String secondaryText;
//
//   StructuredFormatting({
//     required this.mainText,
//     required this.mainTextMatchedSubstrings,
//     required this.secondaryText,
//   });
//
//   factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
//     return StructuredFormatting(
//       mainText: json['main_text'],
//       mainTextMatchedSubstrings: (json['main_text_matched_substrings'] as List)
//           .map((e) => MatchedSubstring.fromJson(e))
//           .toList(),
//       secondaryText: json['secondary_text'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'main_text': mainText,
//       'main_text_matched_substrings': mainTextMatchedSubstrings.map((e) => e.toJson()).toList(),
//       'secondary_text': secondaryText,
//     };
//   }
// }
//
// class Term {
//   final int offset;
//   final String value;
//
//   Term({
//     required this.offset,
//     required this.value,
//   });
//
//   factory Term.fromJson(Map<String, dynamic> json) {
//     return Term(
//       offset: json['offset'],
//       value: json['value'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'offset': offset,
//       'value': value,
//     };
//   }
// }
//
// class PredictionsResponse {
//   final List<Prediction> predictions;
//
//   PredictionsResponse({
//     required this.predictions,
//   });
//
//   factory PredictionsResponse.fromJson(Map<String, dynamic> json) {
//     return PredictionsResponse(
//       predictions: (json['predictions'] as List)
//           .map((e) => Prediction.fromJson(e))
//           .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'predictions': predictions.map((e) => e.toJson()).toList(),
//     };
//   }
// }


import 'package:easypg/utils/tools.dart';

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
  static List<PostOffice> parseResponse(Map<String,dynamic> json,String state) {
    List<PostOffice> postOffices = (json['PostOffice'] as List)
        .map((postOffice) => PostOffice.fromJson(postOffice))
        .toList();

    postOffices.removeWhere(
          (element) => element.state != state,
    );
    postOffices = removeDuplicatesByPincode(postOffices);
    return postOffices;
  }
  static List<PostOffice> removeDuplicatesByPincode(List<PostOffice> postOffices) {
    Set<String> seenPincodes = List.generate(postOffices.length, (index) => postOffices[index].pincode,).toSet();
    return List.generate(seenPincodes.length, (index) => postOffices[postOffices.indexWhere((element) => element.pincode == seenPincodes.elementAt(index),)],);
  }
}
