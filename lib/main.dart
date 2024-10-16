import 'dart:io';

import 'package:easypg/auth/login.dart';
import 'package:easypg/auth/register_screen.dart';
import 'package:easypg/firebase_options.dart';
import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/provider/auth_provider.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/main_screen.dart';
import 'package:easypg/screens/splash.dart';
import 'package:easypg/screens/views/profile/profile.dart';
import 'package:easypg/services/app_configs.dart';
import 'package:easypg/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }
  await AppConfigs.instance.getConfigs();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthDataProvider.instance,
      ),
      ChangeNotifierProvider(
        create: (context) => DataProvider.instance,
      ),
      ChangeNotifierProvider(
        create: (context) => AddPropertyProvider.instance,
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        showSemanticsDebugger: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: myOrange),
          useMaterial3: true,
        ),
        home: const Splash(),
        routes: {
          LoginScreen.route: (context) => const LoginScreen(),
          RegisterScreen.route: (context) => const RegisterScreen(),
          MainScreen.route: (context) => const MainScreen(),
          ProfileScreen.route: (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
