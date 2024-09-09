import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

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
