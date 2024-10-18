import 'package:easypg/auth/login.dart';
import 'package:easypg/auth/register_screen.dart';
import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/provider/auth_provider.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/main_screen.dart';
import 'package:easypg/screens/splash.dart';
import 'package:easypg/screens/views/profile/profile.dart';
import 'package:easypg/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
