import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/utils/tools.dart';

class FirebaseController extends ApiHandler{
  FirebaseFirestore instance = FirebaseFirestore.instance;
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

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
}