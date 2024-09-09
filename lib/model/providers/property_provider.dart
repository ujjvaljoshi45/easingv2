import 'dart:typed_data';

import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:flutter/widgets.dart';

class PropertyProvider extends ChangeNotifier {
  Property property = Property();

  List<Uint8List> uploadImages = [];
  Future<void> setStateAndCity(String pinCode) async {
    property.city = 'myCity';
    property.state = 'myState';
  }

  Future<void> uploadToFirestore() async => ApiHandler.instance.saveProperty(property);
}