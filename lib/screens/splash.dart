import 'package:easypg/auth/login.dart';
import 'package:easypg/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:easypg/provider/auth_provider.dart' as auth;

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
    if (await auth.AuthDataProvider.instance.checkUser()) {
      mounted ? Navigator.pushNamed(context, MainScreen.route) : null;
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
