import 'dart:io';

import 'package:easypg/auth/login.dart';
import 'package:easypg/firebase_options.dart';
import 'package:easypg/screens/main_screen.dart';
import 'package:easypg/services/ad_service.dart';
import 'package:easypg/services/app_configs.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/tools.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easypg/provider/auth_provider.dart' as auth;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Splash extends StatefulWidget {
  static String route = 'splash';
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void didChangeDependencies() async {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      await Firebase.initializeApp();
    }
    await AppConfigs.instance.getConfigs();
    await AdService.instance.loadAd();
    if (await auth.AuthDataProvider.instance.checkUser()) {
      mounted ? Navigator.pushNamed(context, MainScreen.route) : null;
    } else {
      mounted ? Navigator.of(context).pushNamed(LoginScreen.route) : null;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: getWidth(context) * 0.5,
          height: getWidth(context),
          child: LoadingIndicator(
            indicatorType: Indicator.ballScaleRippleMultiple,
            strokeWidth: 10.w,
            pathBackgroundColor: myOrange,
            colors: [myOrangeSecondary, myOrange, pinColor].reversed.toList(),
          ),
        ),
      ),
    );
  }
}
