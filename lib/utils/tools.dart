import 'package:easypg/model/property.dart';
import 'package:easypg/model/providers/data_provider.dart';
import 'package:easypg/model/providers/property_provider.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

logEvent(msg) => Logger().d(msg, time: DateTime.now());
logError(msg, e, StackTrace stackTrace) =>
    Logger().e(msg, error: e, stackTrace: stackTrace, time: DateTime.now());
space(double height) => SizedBox(
      height: height,
    );
printHeading(String text) => Text(
      text,
      style: montserrat.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
    );
showToast(msg, color) =>
    Fluttertoast.showToast(msg: msg, backgroundColor: color);

getHeight(context) => MediaQuery.sizeOf(context).height;
getWidth(context) => MediaQuery.sizeOf(context).width;
Property getPropertyProvider(context) => Provider.of<PropertyProvider>(context, listen: false).property;
AppUser getAppUser(context) => Provider.of<DataProvider>(context,listen: false).getUser;