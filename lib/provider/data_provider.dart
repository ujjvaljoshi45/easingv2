import 'package:easypg/model/cache_manager.dart';
import 'package:easypg/model/user.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  late AppUser _user;
  static final DataProvider instance = DataProvider._();
  DataProvider._();
  void initUser(AppUser user) {
    _user = user;
    CacheManager.user = user;
  }

  AppUser get getUser => _user;
  AppUser setUser(AppUser user) {
    CacheManager.user = _user;
    return _user = user;
  }
  void manageBookmark(String id, bool add)  {
    add ? _user.bookmarks.add(id) : _user.bookmarks.remove(id);
    _user.bookmarks = _user.bookmarks.toSet().toList();
    notifyListeners();
  }
}