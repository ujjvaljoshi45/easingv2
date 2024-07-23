import 'package:easypg/model/cache_manager.dart';
import 'package:easypg/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DataProvider with ChangeNotifier {
  // static Provider<DataProvider> dataProvider(context) => Provider.of<DataProvider>(context,listen: false);
  late AppUser _user;
  void initUser(AppUser user) {
    this._user = user;
    CacheManager.user = user;
  }

  AppUser get getUser => _user;
  AppUser setUser(AppUser user) {
    CacheManager.user = this._user;
    return this._user = user;
  }
}