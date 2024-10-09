import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypg/model/cache_manager.dart';
import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/utils/keys.dart';
import 'package:easypg/utils/tools.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseController extends ApiHandler {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  CollectionReference propertyRef = FirebaseFirestore.instance.collection('properties');

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

  @override
  Future<void> saveUser(AppUser user) async {
    try {
      await userRef.doc(user.uid).set(user.toJson());
    } on FirebaseException catch (e, stackTrace) {
      logError('setUser()', e.toString(), stackTrace);
    } catch (e, stackTrace) {
      logError('setUser()', e.toString(), stackTrace);
    }
  }

  Future<void> saveBookMark(String id, bool add) async {
    try {
      await userRef.doc(DataProvider.instance.getUser.uid).update({
        'bookmarks': add ? FieldValue.arrayUnion([id]) : FieldValue.arrayRemove([id])
      });
      logEvent('bookmark added');
    } catch (e, stackTrace) {
      logError('Error Saving Bookmark', e, stackTrace);
    }
  }

  Future<List<Property>> getProperties() async {
    List<Property> properties = [];
    // if (CacheManager.propertyCache.isNotEmpty) {
    //   logEvent('Getting old ones...');
    //   return CacheManager.propertyCache;
    // }
    try {
      List response = (await propertyRef
              .where('uploader_id', isNotEqualTo: DataProvider.instance.getUser.uid)
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

  Future<void> saveProperty(Property property) async {
    Map res = property.toJson();
    await propertyRef.doc(property.id).set(res);
    await userRef.doc(DataProvider.instance.getUser.uid).update({
      myPropertiesKey: FieldValue.arrayUnion([property.id])
    });
    AddPropertyProvider.instance.clear();
  }

  Future<List<Property>> getPropertiesById([bool? mine]) async {
    List<Property> properties = [];
    if (mine != null) {
      if (mine) {
        final response = (await propertyRef
                .where('uploader_id', isEqualTo: DataProvider.instance.getUser.uid)
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

  Future<List<Property>> queryProperties(String query, String? propertyType) async {
    try {
      List<Future<QuerySnapshot>> futures = [
        propertyRef.where('name', isEqualTo: query).get(),
        propertyRef.where('street_address', isEqualTo: query).get(),
        propertyRef.where('city', isEqualTo: query).get(),
        propertyRef.where('state', isEqualTo: query).get(),
      ];

      // Wait for all queries to complete
      List<QuerySnapshot> querySnapshots = await Future.wait(futures);

      // Combine results and remove duplicates
      Set<Property> allResults = {};
      for (var snapshot in querySnapshots) {
        for (var data in snapshot.docs) {
          allResults.add(Property.fromJson(data.data() as Map<String, dynamic>, data.id));
        }
      }

      return allResults.toList();
    } catch (e, stackTrace) {
      logError('msg$query $propertyType', e, stackTrace);
      return [];
    }
  }

  Future<void> deleteProperty(String id) async => await propertyRef.doc(id).delete().whenComplete(
        () async => await userRef.doc(DataProvider.instance.getUser.uid).update({
          'property': FieldValue.arrayRemove([id])
        }),
      );
}
