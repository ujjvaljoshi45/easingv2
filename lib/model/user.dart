import 'package:easypg/utils/keys.dart';
import 'package:easypg/utils/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  String uid;
  String displayName;
  String phoneNo;
  String profileUrl;
  String gender;
  DateTime bDate;
  List<dynamic> fcm = [];

  AppUser(
      {required this.uid,
      required this.displayName,
      required this.profileUrl,
      required this.phoneNo,
      required this.bDate,
      required this.gender});

  Map<String, dynamic> toJson() => {
        uidKey: uid,
        displayNameKey: displayName,
        phoneNoKey: phoneNo,
        profileUrlKey: profileUrl,
        genderKey: gender,
        bDateKey: bDate,
        fcmKey: fcm,
      };

  factory AppUser.fromFirebaseUser(User user) {

    return AppUser(uid: user.uid, displayName: user.displayName ?? 'U', profileUrl: user.photoURL ?? 'U', phoneNo: user.phoneNumber!, bDate: DateTime.now(), gender: 'NOT SET');
  }

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
      uid: json[uidKey],
      displayName: json[displayNameKey],
      profileUrl: json[profileUrlKey],
      phoneNo: json[phoneNoKey],
      bDate: json[bDateKey].runtimeType == DateTime
          ? json[bDateKey]
          : json[bDateKey].toDate(),
      gender: json[genderKey])
    ..fcm = json[fcmKey];
}
