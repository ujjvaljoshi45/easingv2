import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypg/model/cache_manager.dart';
import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/services/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/utils/app_keys.dart';
import 'package:easypg/utils/keys.dart';
import 'package:easypg/utils/tools.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseController extends ApiHandler {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  CollectionReference configsRef = FirebaseFirestore.instance.collection(AppKeys.configs);
  CollectionReference userRef = FirebaseFirestore.instance.collection(AppKeys.users);
  CollectionReference propertyRef = FirebaseFirestore.instance.collection(AppKeys.properties);
  CollectionReference walletRef = FirebaseFirestore.instance.collection(AppKeys.wallet);

  Future<Map<String, dynamic>> getConfigs() async {
    final jsonArray = (await configsRef.get()).docs;
    Map<String, dynamic> configs = {};
    for (var json in jsonArray) {
      configs[json.id] = json.data();
    }
    return configs;
  }

  // Fetches a user by their UID
  @override
  Future<AppUser?> getUser(String uid) async {
    try {
      final response = (await userRef.doc(uid).get()).data();
      logEvent('Got Response : ${response != null} for $uid');
      if (response == null) return null;
      return AppUser.fromJson(response as Map<String, dynamic>);
    } on FirebaseException catch (e, stackTrace) {
      logError('getUser()', e.toString(), stackTrace);
    } catch (e, stackTrace) {
      logError('getUser()', e.toString(), stackTrace);
    }
    return null;
  }

  // Saves a user's data to Firestore
  @override
  Future<void> saveUser(AppUser user) async {
    try {
      await userRef.doc(user.phoneNo).set(user.toJson());
      await walletRef.doc(user.phoneNo).set({AppKeys.currentBalance: 150});
    } on FirebaseException catch (e, stackTrace) {
      logError('setUser()', e.toString(), stackTrace);
    } catch (e, stackTrace) {
      logError('setUser()', e.toString(), stackTrace);
    }
  }

  // Updates user's bookmark list
  Future<void> saveBookMark(String id, bool add) async {
    try {
      await userRef.doc(DataProvider.instance.getUser.uid).update({
        AppKeys.bookmarks: add ? FieldValue.arrayUnion([id]) : FieldValue.arrayRemove([id])
      });
      logEvent('bookmark added');
    } catch (e, stackTrace) {
      logError('Error Saving Bookmark', e, stackTrace);
    }
  }

  // Fetches properties not uploaded by the current user
  Future<List<Property>> getProperties() async {
    List<Property> properties = [];
    try {
      List response = (await propertyRef
              .where(AppKeys.uploaderId, isNotEqualTo: DataProvider.instance.getUser.uid)
              .get())
          .docs;
      for (var data in response) {
        properties.add(Property.fromJson(data.data(), data.id));
      }
    } catch (e, stackTrace) {
      logError('getProperties() error', e, stackTrace);
    }
    CacheManager.propertyCache = properties;
    return properties;
  }

  // Uploads images and returns their URLs
  Future<List<String>> saveImages(List<String> paths, int time) async {
    List<String> urls = [];
    for (String path in paths) {
      final ref = FirebaseStorage.instance
          .ref('property/${DataProvider.instance.getUser.uid}/$time/${paths.indexOf(path)}.jpg');
      await ref.putFile(File(path));
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  // Saves a property and updates the user's property list
  Future<void> saveProperty(Property property) async {
    Map res = property.toJson();
    await propertyRef.doc(property.id).set(res);
    await userRef.doc(DataProvider.instance.getUser.uid).update({
      myPropertiesKey: FieldValue.arrayUnion([property.id])
    });
    AddPropertyProvider.instance.clear();
  }

  // Fetches properties by ID, filtering by ownership if specified
  Future<List<Property>> getPropertiesById([bool? mine]) async {
    List<Property> properties = [];
    if (mine != null) {
      if (mine) {
        final response = (await propertyRef
                .where(AppKeys.uploaderId, isEqualTo: DataProvider.instance.getUser.uid)
                .get())
            .docs;
        for (var json in response) {
          properties.add(Property.fromJson(json.data() as Map<String, dynamic>, json.id));
        }
        return properties;
      }
    }
    final response = await userRef.doc(DataProvider.instance.getUser.uid).get();
    final ids = response.get(bookMarksKey);
    logEvent('ids : ${ids.length}');
    for (var id in ids) {
      logEvent('searching... id: $id');
      properties.add(
          Property.fromJson((await propertyRef.doc(id).get()).data() as Map<String, dynamic>, id));
    }
    logEvent('properties ${properties.length}');
    return properties;
  }

  // Searches properties based on tags and optional property type
  Future<List<Property>> queryProperties(String query, String? propertyType) async {
    try {
      List<QueryDocumentSnapshot> querySnapshots =
          (await propertyRef.where(AppKeys.tags, arrayContainsAny: query.split(" ")).get()).docs;
      List<Property> allResults = [];
      for (var json in querySnapshots) {
        allResults.add(Property.fromJson(json.data() as Map<String, dynamic>, json.id));
      }
      return allResults.toList();
    } catch (e, stackTrace) {
      logError('msg$query $propertyType', e, stackTrace);
      return [];
    }
  }

  // Deletes a property and updates the user's list
  Future<void> deleteProperty(String id) async => await propertyRef.doc(id).delete().whenComplete(
        () async => await userRef.doc(DataProvider.instance.getUser.uid).update({
          AppKeys.property: FieldValue.arrayRemove([id])
        }),
      );
  Stream<DocumentSnapshot<Object?>> get walletStream =>
      walletRef.doc(DataProvider.instance.getUser.uid).snapshots();

  Future<int?> getWallet() async {
    try {
      final myAmount = (await walletRef.doc(DataProvider.instance.getUser.uid).get())
          .get(AppKeys.currentBalance) as int?;
      return myAmount;
    } catch (e, stackTrace) {
      logError('getWallet', e, stackTrace);
      return null;
    }
  }

  Future<void> updateMoneyToWallet(int amount) async {
    try {
      await walletRef
          .doc(DataProvider.instance.getUser.uid)
          .update({AppKeys.currentBalance: FieldValue.increment(amount)});
      await updatePaymentsHistory(amount > 0, amount);
    } catch (e, stackTrace) {
      await walletRef.doc(DataProvider.instance.getUser.uid).set({AppKeys.currentBalance: amount});
      await updatePaymentsHistory(amount > 0, amount);
      logError('updateMoneyToWallet', e, stackTrace);
    }
  }

  Future<void> updatePaymentsHistory(bool isCredit, int amount) async => await walletRef
      .doc(DataProvider.instance.getUser.uid)
      .collection(AppKeys.history)
      .doc(DateTime.now().millisecondsSinceEpoch.toString())
      .set({AppKeys.isCredit: isCredit, AppKeys.amount: amount});

  Future<QuerySnapshot<Object?>> paymentHistory() async => await walletRef
      .doc(DataProvider.instance.getUser.uid)
      .collection(AppKeys.history)
      .get();

  Future<bool> updateActivation(String id) async {
    try {
      await propertyRef.doc(id).update({AppKeys.statusKey: true});
      return true;
    } catch (e) {
      return false;
    }
  }
}
