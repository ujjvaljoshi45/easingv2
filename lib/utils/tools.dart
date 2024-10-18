import 'package:easypg/screens/views/profile/profile.dart';
import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher_string.dart';

logEvent(msg) => Logger().d(msg, time: DateTime.now());
logError(msg, e, StackTrace stackTrace) =>
    Logger().e(msg, error: e, stackTrace: stackTrace, time: DateTime.now());
space(double height) => SizedBox(
      height: height.h,
    );
printHeading(String text) => Text(
      text,
      style: montserrat.copyWith(fontWeight: FontWeight.bold, fontSize: 20.sp),
    );
void showToast(String msg, [Color? color, Color? textColor]) =>
    Fluttertoast.showToast(msg: msg, backgroundColor: color, textColor: textColor);

double getHeight(context) => MediaQuery.sizeOf(context).height.h;
double getWidth(context) => MediaQuery.sizeOf(context).width.w;

showInsufficientBalanceSnackBar(BuildContext context) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text("You Don't Have Enough Balance"),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, ProfileScreen.route),
              child: Text("Recharge"),
            ),
          ],
        ),
      ),
    );

Future<void> manageUrl(String myUrl) async => await launchUrlString(
      myUrl,
      mode: LaunchMode.inAppBrowserView,
      browserConfiguration: BrowserConfiguration(showTitle: true),
      webOnlyWindowName: 'Easy PG',
    );

Color getPrimary(BuildContext context) => Theme.of(context).colorScheme.primary;
Color getOnPrimary(BuildContext context) => Theme.of(context).colorScheme.onPrimary;
Color getSecondary(BuildContext context) => Theme.of(context).colorScheme.secondary;
Color getOnSecondary(BuildContext context) => Theme.of(context).colorScheme.onSecondary;
