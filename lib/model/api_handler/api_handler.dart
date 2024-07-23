import 'package:easypg/model/api_handler/firebase_controller.dart';
import 'package:easypg/model/user.dart';

abstract class ApiHandler {
  static FirebaseController instance = FirebaseController();
  Future<void> saveUser(AppUser user);
  Future<AppUser?> getUser(String uid);
}