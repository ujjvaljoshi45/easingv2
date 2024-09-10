import 'package:easypg/auth/login.dart';
import 'package:easypg/auth/otp_screen.dart';
import 'package:easypg/auth/register_screen.dart';
import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/home_screen.dart';
import 'package:easypg/utils/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  static final AuthProvider instance = AuthProvider._privateConstructor();
  AuthProvider._privateConstructor();
  String? _verificationId;

  toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<void> requestOtp(String phoneNumber, BuildContext context) async {
    // toggleLoading();
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await _signInWIthPhoneAuthCredential(
            phoneAuthCredential,
            context,
            phoneNumber,
          );
        },
        verificationFailed: (error) {
          logError('${error.message}', error, StackTrace.empty);
        },
        codeSent: (verificationId, forceResendingToken) async {
          _verificationId = verificationId;
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return OptInputScreen(phoneNumber: phoneNumber,);
            },
          ));
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e, stackTrace) {
      logError('otp failed', e, stackTrace);
    }
    // toggleLoading();
  }

  Future<void> verifyOtp(String otp, BuildContext context, String phoneNumber) async {
    // toggleLoading();
    try {
      if (_verificationId != null) {
        final phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: otp,
        );
        await _signInWIthPhoneAuthCredential(
          phoneAuthCredential,
          context,
          phoneNumber,
        );
      }
    } catch (e, stackTrace) {
      logError('verify failed', e, stackTrace);
    }
    // toggleLoading();
  }

  Future<void> _signInWIthPhoneAuthCredential(
      PhoneAuthCredential credential, BuildContext context, String phoneNumber) async {
    try {
      final userCredential = await auth.signInWithCredential(credential);
      if (userCredential.additionalUserInfo!.isNewUser) {
        _saveNewEntry(userCredential,context);
      } else {
        try {
          AppUser? user = await ApiHandler.instance.getUser(userCredential.user!.uid);
          if (user == null) throw ('Null User');
          DataProvider.instance.setUser(user);
          Navigator.of(context).pushReplacementNamed(HomeScreen.route);
        } catch (e) {
          _saveNewEntry(userCredential,context);
        }
      }

    } catch (e) {
      Navigator.of(context).pushReplacementNamed(LoginScreen.route);
    }
  }

  _saveNewEntry(userCredential,context) async {
    AppUser user = AppUser.fromFirebaseUser(userCredential.user!);
    await ApiHandler.instance.saveUser(user);
    DataProvider.instance.initUser(user);
    Navigator.pushReplacementNamed(context, RegisterScreen.route);
  }
}
