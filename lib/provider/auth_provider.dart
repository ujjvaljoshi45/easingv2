import 'package:easypg/auth/login.dart';
import 'package:easypg/auth/otp_screen.dart';
import 'package:easypg/auth/register_screen.dart';
import 'package:easypg/services/api_handler.dart';
import 'package:easypg/model/cache_manager.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/main_screen.dart';
import 'package:easypg/utils/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Authentication data provider using the ChangeNotifier to notify listeners
class AuthDataProvider extends ChangeNotifier {
  bool isLoading = false; // Indicates loading state for general actions
  bool isOtpLoading = false; // Indicates loading state for OTP-related actions
  final FirebaseAuth auth = FirebaseAuth.instance; // FirebaseAuth instance
  static final AuthDataProvider instance =
      AuthDataProvider._privateConstructor(); // Singleton instance

  AuthDataProvider._privateConstructor();

  String? _verificationId; // Stores the verification ID for OTP
  int? _forceResendingToken; // Token for resending OTP
  String? phoneNumber; // Stores the user's phone number

  // Toggles loading state
  toggleLoading() {
    isLoading = !isLoading;
    notifyListeners(); // Notify listeners about state change
  }

  // Toggles OTP loading state
  toggleOtpLoading() {
    isOtpLoading = !isOtpLoading;
    notifyListeners(); // Notify listeners about state change
  }

  // Requests OTP verification for the given phone number
  Future<void> requestOtp(String phoneNumber, BuildContext context) async {
    toggleLoading(); // Start loading
    this.phoneNumber = phoneNumber; // Save phone number
    isOtpLoading = false; // Reset OTP loading state

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        forceResendingToken: _forceResendingToken,
        // Automatically sign in if verification is completed
        verificationCompleted: (phoneAuthCredential) async {
          await _signInWIthPhoneAuthCredential(
            phoneAuthCredential,
            context,
            phoneNumber,
          );
        },
        // Handle verification failure
        verificationFailed: (error) {
          logError('${error.message}', error, StackTrace.empty);
        },
        // Code sent to the user's phone, navigate to OTP screen
        codeSent: (verificationId, forceResendingToken) async {
          _verificationId = verificationId; // Save verification ID
          _forceResendingToken = forceResendingToken; // Save force resending token
          toggleLoading(); // Stop loading

          // Navigate to OTP input screen
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return OptInputScreen(
                phoneNumber: phoneNumber,
              );
            },
          ));
        },
        // Handle auto-retrieval timeout
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId; // Save verification ID
        },
      );
    } catch (e, stackTrace) {
      logError('otp failed', e, stackTrace); // Log error if OTP request fails
      if (isLoading) toggleLoading(); // Stop loading if needed
    }
  }

  // Verifies the provided OTP
  Future<void> verifyOtp(String otp, BuildContext context, String phoneNumber) async {
    toggleOtpLoading(); // Start OTP loading
    try {
      if (_verificationId != null) {
        // Create PhoneAuthCredential with verification ID and OTP
        final phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: otp,
        );
        // Sign in with the PhoneAuthCredential
        await _signInWIthPhoneAuthCredential(
          phoneAuthCredential,
          context,
          phoneNumber,
        );
        // toggleOtpLoading();
      }
    } catch (e, stackTrace) {
      showToast('Unable to Verify OTP!', Colors.red, Colors.white); // Show error message
      logError('verify failed', e, stackTrace); // Log verification error
      toggleOtpLoading();
    }
  }

  // Signs in using the provided PhoneAuthCredential
  Future<void> _signInWIthPhoneAuthCredential(
      PhoneAuthCredential credential, BuildContext context, String phoneNumber) async {
    final userCredential = await auth.signInWithCredential(credential); // Sign in with credential

    // If user is null, redirect to the login screen
    if (userCredential.user == null) {
      Navigator.pushReplacementNamed(context, LoginScreen.route);
      return;
    }

    // Check if the user exists in the database
    AppUser? appUser = await ApiHandler.instance.getUser(userCredential.user!.uid);
    if (appUser == null) {
      _saveNewEntry(userCredential, context); // Save new user if not found
      return;
    } else {
      DataProvider.instance.initUser(appUser); // Initialize user data
      Navigator.pushReplacementNamed(context, MainScreen.route); // Navigate to main screen
    }
  }

  // Saves a new user entry in the database
  _saveNewEntry(userCredential, context) async {
    AppUser user =
        AppUser.fromFirebaseUser(userCredential.user!); // Create AppUser from Firebase user
    await ApiHandler.instance.saveUser(user); // Save user to the database
    DataProvider.instance.initUser(user); // Initialize user data
    Navigator.pushReplacementNamed(
        context, RegisterScreen.route); // Navigate to registration screen
  }

  // Logs out the current user
  Future<bool> logout(BuildContext context) async {
    try {
      CacheManager.user = null; // Clear cached user data
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase
      Navigator.pushReplacementNamed(context, LoginScreen.route); // Navigate to login screen
      return true;
    } catch (e) {
      return false; // Return false if logout fails
    }
  }

  // Checks if there is a currently signed-in user
  Future<bool> checkUser() async {
    logEvent(auth.currentUser == null);
    if (auth.currentUser == null) return false; // Return false if no user is signed in

    // Get the user data from the database
    final jsonUser = await ApiHandler.instance.getUser(auth.currentUser!.uid);
    if (jsonUser == null) return false; // Return false if user not found

    DataProvider.instance.initUser(jsonUser); // Initialize user data
    return true; // Return true if user exists
  }
}
