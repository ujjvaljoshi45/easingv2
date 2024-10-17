import 'package:easypg/utils/app_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  String uid;
  String displayName;
  String phoneNo;
  String profileUrl;
  String gender;
  DateTime bDate;
  List<dynamic> fcm = [];
  List<String> bookmarks = [];
  List<String> myProperties = [];
  bool isAadharVerified = false;
  AppUser({
    required this.uid,
    required this.displayName,
    required this.profileUrl,
    required this.phoneNo,
    required this.bDate,
    required this.gender,
    required this.isAadharVerified,
  });

  factory AppUser.fromFirebaseUser(User user) {
    return AppUser(
        uid: user.uid,
        displayName: user.displayName ?? '',
        profileUrl: user.photoURL ?? '',
        phoneNo: user.phoneNumber!,
        bDate: DateTime.now(),
        gender: 'NOT SET',
        isAadharVerified: false);
  }

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
      uid: json[AppKeys.uidKey],
      displayName: json[AppKeys.displayNameKey],
      profileUrl: json[AppKeys.profileUrlKey],
      phoneNo: json[AppKeys.phoneNoKey],
      bDate: json[AppKeys.bDateKey].runtimeType == DateTime ? json[AppKeys.bDateKey] : json[AppKeys.bDateKey].toDate(),
      gender: json[AppKeys.genderKey],
      isAadharVerified: json[AppKeys.isAadharVerifiedKey])
    ..fcm = json[AppKeys.fcmKey]
    ..bookmarks = json[AppKeys.bookMarksKey] == null
        ? []
        : List.generate(
            json[AppKeys.bookMarksKey].length,
            (index) => json[AppKeys.bookMarksKey][index],
          )
    ..myProperties = json[AppKeys.myPropertiesKey] == null
        ? []
        : List.generate(
            json[AppKeys.myPropertiesKey].length,
            (index) => json[AppKeys.myPropertiesKey][index],
          );

  Map<String, dynamic> toJson() => {
        AppKeys.uidKey: uid,
        AppKeys.displayNameKey: displayName,
        AppKeys.phoneNoKey: phoneNo,
        AppKeys.profileUrlKey: profileUrl,
        AppKeys.genderKey: gender,
        AppKeys.bDateKey: bDate,
        AppKeys.fcmKey: fcm,
        AppKeys.bookMarksKey: bookmarks,
        AppKeys.isAadharVerifiedKey: isAadharVerified
      };
}
