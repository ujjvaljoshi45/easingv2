import 'package:easypg/auth/login.dart';
import 'package:easypg/auth/register_screen.dart';
import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/screens/home_screen.dart';
import 'package:easypg/utils/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  static String route = 'splash';
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void didChangeDependencies() async {
    await Future.delayed(const Duration(seconds: 1));
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AppUser? appUser = await ApiHandler.instance.getUser(user.uid);
      if (appUser == null) {
        appUser = AppUser.fromFirebaseUser(user);
        mounted ? DataProvider.instance.initUser(appUser) : null;
        mounted ? Navigator.pushNamed(context, RegisterScreen.route) : null;
      } else {
        DataProvider.instance.initUser(appUser);
        mounted ? Navigator.pushNamed(context, HomeScreen.route) : null;
      }
    } else {
      mounted ? Navigator.of(context).pushNamed(LoginScreen.route) : null;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
