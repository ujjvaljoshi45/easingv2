import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypg/model/add_property_provider.dart';
import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/cache_manager.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/utils/tools.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseController extends ApiHandler{
  FirebaseFirestore instance = FirebaseFirestore.instance;
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  CollectionReference propertyRef = FirebaseFirestore.instance.collection('properties');

  @override
  Future<AppUser?> getUser(String uid) async {
    try{
      final response = (await userRef.doc(uid).get()).data();
      logEvent('Got Response : ${response != null} for $uid');
      if (response == null) return null;
      return AppUser.fromJson(response as Map<String,dynamic>);

    } on FirebaseException catch (e,stackTrace) {
      logError('getUser()', e.toString(),stackTrace );
    } catch (e, stackTrace) {
      logError('getUser()', e.toString(),stackTrace );
    }

    return null;
  }

  @override
  Future<void> saveUser(AppUser user) async {
    try{
      await userRef.doc(user.uid).set(user.toJson());
    } on FirebaseException catch (e,stackTrace) {
      logError('setUser()', e.toString(),stackTrace );
    } catch (e, stackTrace) {
      logError('setUser()', e.toString(),stackTrace );
    }
  }

  Future<List<Property>> getProperties() async {
    List<Property> properties = [];
    try {
      List response = (await propertyRef.get()).docs;
      for (var data in response) {
        properties.add(Property.fromJson(data.data()));
      }
    } catch (e,stackTrace) {
      logError('getProperties() error', e, stackTrace);
    }
    return properties;
  }

  Future<List<String>> saveImages(List<String> paths) async {
    List<String> urls = [];
    for (String path in paths) {
       final ref = FirebaseStorage.instance.ref('property/${CacheManager.user!.uid}/${CacheManager.user!.myProperties.length+1}/');
       await ref.putFile(File(path));
       urls.add(await ref.getDownloadURL());
    }
    return urls;
  }
  void saveProperty(Property property) async {
    Map res = property.toJson();
    res.putIfAbsent('uploader_id', () => CacheManager.user!.uid,);
    await propertyRef.add(res);
    AddPropertyProvider.instance.clear();
  }
}