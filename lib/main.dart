import 'dart:io';

import 'package:easypg/auth/login.dart';
import 'package:easypg/auth/register_screen.dart';
import 'package:easypg/firebase_options.dart';
import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/provider/auh_provider.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/home_screen.dart';
import 'package:easypg/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AuthProvider.instance,),
      ChangeNotifierProvider(create: (context) => DataProvider.instance,),
      ChangeNotifierProvider(create: (context) => AddPropertyProvider.instance,),
    ],child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
     home: const Splash(),
      routes: {
        LoginScreen.route : (context) => const LoginScreen(),
        RegisterScreen.route : (context) => const RegisterScreen(),
        HomeScreen.route : (context) => const HomeScreen(),
      },
    );
  }
}
