import 'package:easypg/model/property.dart';
import 'package:easypg/model/user.dart';

abstract class CacheManager {
  static AppUser? user;
  static List<Property> propertyCache = [];
}
