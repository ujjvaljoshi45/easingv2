// import 'package:dio/dio.dart';
// import 'package:easypg/model/prediction.dart';
// import 'package:easypg/utils/tools.dart';
// import 'package:flutter/material.dart';
//
// const String API_KEY = "AIzaSyBRF2xDjHE_0ymJMKS0adJL-cAvYyTn1oo";
//
// class SearchPlaces extends StatefulWidget {
//   const SearchPlaces({super.key});
//
//   @override
//   State<SearchPlaces> createState() => _SearchPlacesState();
// }
//
// class _SearchPlacesState extends State<SearchPlaces> {
//   // List<Prediction> result = [];
//
//   Future<void> placesAutoComplete(String query) async {
//     Uri uri = Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json",
//         {"input": query, "key": API_KEY});
//     try {
//       final response = Response(requestOptions: RequestOptions(baseUrl: "https://maps.googleapis.com",queryParameters: uri.queryParameters,path: uri.path), data: {
//         "predictions": [
//           {
//             "description": "Shagun Plaza, Nyay Marg, Vastrapur, Ahmedabad, Gujarat, India",
//             "matched_substrings": [
//               {"length": 12, "offset": 0}
//             ],
//             "place_id": "ChIJySo6frWEXjkRntzuHWSrGjk",
//             "reference": "ChIJySo6frWEXjkRntzuHWSrGjk",
//             "structured_formatting": {
//               "main_text": "Shagun Plaza",
//               "main_text_matched_substrings": [
//                 {"length": 12, "offset": 0}
//               ],
//               "secondary_text": "Nyay Marg, Vastrapur, Ahmedabad, Gujarat, India"
//             },
//             "terms": [
//               {"offset": 0, "value": "Shagun Plaza"},
//               {"offset": 14, "value": "Nyay Marg"},
//               {"offset": 25, "value": "Vastrapur"},
//               {"offset": 36, "value": "Ahmedabad"},
//               {"offset": 47, "value": "Gujarat"},
//               {"offset": 56, "value": "India"}
//             ],
//             "types": ["premise", "geocode"]
//           },
//           {
//             "description":
//                 "Shagun Plaza,near prajapati resort, Nuasahi, Nayapalli, Bhubaneswar, Odisha, India",
//             "matched_substrings": [
//               {"length": 12, "offset": 0}
//             ],
//             "place_id": "ChIJzyhi4NkJGToRzMtIrpqc_6E",
//             "reference": "ChIJzyhi4NkJGToRzMtIrpqc_6E",
//             "structured_formatting": {
//               "main_text": "Shagun Plaza,near prajapati resort",
//               "main_text_matched_substrings": [
//                 {"length": 12, "offset": 0}
//               ],
//               "secondary_text": "Nuasahi, Nayapalli, Bhubaneswar, Odisha, India"
//             },
//             "terms": [
//               {"offset": 0, "value": "Shagun Plaza,near prajapati resort"},
//               {"offset": 36, "value": "Nuasahi"},
//               {"offset": 45, "value": "Nayapalli"},
//               {"offset": 56, "value": "Bhubaneswar"},
//               {"offset": 69, "value": "Odisha"},
//               {"offset": 77, "value": "India"}
//             ],
//             "types": ["establishment", "point_of_interest"]
//           },
//           {
//             "description": "Shagun Plaza, Dandiya Bazar, Vishnupuri, Lucknow, Uttar Pradesh, India",
//             "matched_substrings": [
//               {"length": 12, "offset": 0}
//             ],
//             "place_id": "ChIJZfZz19lXmTkRu5StrrR_r1o",
//             "reference": "ChIJZfZz19lXmTkRu5StrrR_r1o",
//             "structured_formatting": {
//               "main_text": "Shagun Plaza",
//               "main_text_matched_substrings": [
//                 {"length": 12, "offset": 0}
//               ],
//               "secondary_text": "Dandiya Bazar, Vishnupuri, Lucknow, Uttar Pradesh, India"
//             },
//             "terms": [
//               {"offset": 0, "value": "Shagun Plaza"},
//               {"offset": 14, "value": "Dandiya Bazar"},
//               {"offset": 29, "value": "Vishnupuri"},
//               {"offset": 41, "value": "Lucknow"},
//               {"offset": 50, "value": "Uttar Pradesh"},
//               {"offset": 65, "value": "India"}
//             ],
//             "types": ["premise", "geocode"]
//           },
//           {
//             "description": "Shagun Plaza, Vastrapur, Ahmedabad, Gujarat, India",
//             "matched_substrings": [
//               {"length": 12, "offset": 0}
//             ],
//             "place_id": "ChIJcQv2gbWEXjkRhOfYaGnjZBY",
//             "reference": "ChIJcQv2gbWEXjkRhOfYaGnjZBY",
//             "structured_formatting": {
//               "main_text": "Shagun Plaza",
//               "main_text_matched_substrings": [
//                 {"length": 12, "offset": 0}
//               ],
//               "secondary_text": "Vastrapur, Ahmedabad, Gujarat, India"
//             },
//             "terms": [
//               {"offset": 0, "value": "Shagun Plaza"},
//               {"offset": 14, "value": "Vastrapur"},
//               {"offset": 25, "value": "Ahmedabad"},
//               {"offset": 36, "value": "Gujarat"},
//               {"offset": 45, "value": "India"}
//             ],
//             "types": ["premise", "geocode"]
//           },
//           {
//             "description": "Shagun Plaza, Malviya Nagar, Shyampur, Rishikesh, Uttarakhand, India",
//             "matched_substrings": [
//               {"length": 12, "offset": 0}
//             ],
//             "place_id": "ChIJzbVpwfQ-CTkR1I2U0giFKmc",
//             "reference": "ChIJzbVpwfQ-CTkR1I2U0giFKmc",
//             "structured_formatting": {
//               "main_text": "Shagun Plaza",
//               "main_text_matched_substrings": [
//                 {"length": 12, "offset": 0}
//               ],
//               "secondary_text": "Malviya Nagar, Shyampur, Rishikesh, Uttarakhand, India"
//             },
//             "terms": [
//               {"offset": 0, "value": "Shagun Plaza"},
//               {"offset": 14, "value": "Malviya Nagar"},
//               {"offset": 29, "value": "Shyampur"},
//               {"offset": 39, "value": "Rishikesh"},
//               {"offset": 50, "value": "Uttarakhand"},
//               {"offset": 63, "value": "India"}
//             ],
//             "types": ["establishment", "point_of_interest"]
//           }
//         ],
//         "status": "OK"
//       });
//       logEvent('res: ${response.headers}');
//       final predictionsResponse = PredictionsResponse.fromJson(response.data as Map<String, dynamic>);
//       setState(()=>result=predictionsResponse.predictions);
//     } catch (e, stackTrace) {
//       logError('places', e, stackTrace);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Card(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Form(
//               child: TextFormField(
//                 textInputAction: TextInputAction.search,
//                 decoration: const InputDecoration(hintText: 'Search Places'),
//                 onFieldSubmitted: (value) async => await placesAutoComplete(value),
//               ),
//             ),
//           ),
//         ),
//         const Divider(
//           color: Colors.grey,
//           thickness: 2,
//         ),
//         Flexible(
//           child: ListView.builder(
//             itemBuilder: (context, index) => Text(
//               result[index].description,
//             ),
//             itemCount: result.length,
//           ),
//         )
//       ],
//     );
//   }
// }
