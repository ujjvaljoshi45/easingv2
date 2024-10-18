import 'package:easypg/model/cache_manager.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/services/api_handler.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  late AppUser _user; // Private variable to store the current user
  static final DataProvider instance = DataProvider._(); // Singleton instance of DataProvider

  DataProvider._(); // Private constructor to enforce singleton pattern

  // Initializes the user and updates the CacheManager
  void initUser(AppUser user) {
    _user = user; // Set the user
    CacheManager.user = user; // Cache the user data
  }

  // Getter for the current user
  AppUser get getUser => _user;

  // Setter for the current user, also updates the cache
  AppUser setUser(AppUser user) {
    CacheManager.user = _user; // Update cache with current user
    notifyListeners();
    return _user = user; // Update the user and return the new user
  }

  Future<void> refreshUser() async => setUser((await ApiHandler.instance.getUser(_user.uid))!);

  // Manages bookmarks by adding or removing a property ID
  void manageBookmark(String id, bool add) {
    add ? _user.bookmarks.add(id) : _user.bookmarks.remove(id); // Add or remove bookmark
    _user.bookmarks = _user.bookmarks.toSet().toList(); // Remove duplicates
    notifyListeners(); // Notify listeners about changes
  }
}
