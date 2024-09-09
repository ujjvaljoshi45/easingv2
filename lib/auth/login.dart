import 'package:country_code_picker/country_code_picker.dart';
import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/data_provider.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/screens/home_screen.dart';
import 'package:easypg/utils/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class LoginScreen extends StatefulWidget {
  static String route = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//TODO: Create Method
//TODO: Open Bottom Bar For OTP Input
//TODO: Create success, fail etc methods
//TODO: Navigate to respective views
class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoNoController = TextEditingController();
  final TextEditingController _pinputController = TextEditingController();
  String countryCode = "+91";

  String? verificationId;
  int? resendToken;


  Future<AppUser?>_checkUser(String uid) async {
    return await ApiHandler.instance.getUser(uid);

  }
  void _manageLogin() async {
    logEvent('PhoneNO: $countryCode${_phoNoController.text}');
    _auth.verifyPhoneNumber(
        forceResendingToken: resendToken,
        phoneNumber: '$countryCode${_phoNoController.text}',
        timeout: const Duration(seconds: 60),
        verificationCompleted: _verificationCompleted,
        verificationFailed: _verificationFailed,
        codeSent: _codeSent,
        codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout);
  }

  _verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
    logEvent('Running VC');
    setState(()=>_pinputController.setText(phoneAuthCredential.smsCode?? _pinputController.text));
    UserCredential userCredential = await _auth.signInWithCredential(phoneAuthCredential);
    AppUser? appUser = await _checkUser(userCredential.user!.uid);
    if (appUser == null) {
      logEvent('USER : ${userCredential.user?.uid} | ${userCredential.user?.phoneNumber}');
    appUser = AppUser.fromFirebaseUser(userCredential.user!);
    await ApiHandler.instance.saveUser(appUser);
    mounted ? Navigator.pushNamed(context, 'register')  :null;
    } else {
      mounted ? DataProvider.instance.initUser(appUser) : null;
      mounted ? Navigator.pushNamed(context, HomeScreen.route) : null;
    }

  }
  _verificationFailed(FirebaseAuthException error) async {
    Navigator.pop(context);
    showToast('Error Occurred', Colors.redAccent);
  }
  _codeSent(String verificationId, int? forceResendingToken) async {
    this.verificationId = verificationId;
    resendToken = forceResendingToken;
    logEvent(' PRINT: $verificationId | $forceResendingToken');
    _showVerificationModal();
  }
  _codeAutoRetrievalTimeout(String verificationId) async {}

  _verifyOTP() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: _pinputController.text);

    UserCredential userCredential = await _auth.signInWithCredential(phoneAuthCredential);

    if (userCredential.user != null) {
      mounted ? DataProvider.instance.initUser(AppUser.fromFirebaseUser(userCredential.user!)) : null;
      mounted ? Navigator.pushNamed(context, HomeScreen.route) : null;
    } else {
      mounted ? Navigator.pop(context) : null;
      showToast('Error Occurred in Verifying OTP', Colors.redAccent);
    }
  }

  _showVerificationModal() async => showModalBottomSheet(isDismissible: false, context: context, builder: (context) {
      return Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: SingleChildScrollView(
          child: SizedBox(
            // heightFactor: 0.5,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Padding(
              padding: const EdgeInsets.only( top: 12.0,left: 12.0,right: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Enter OTP',style: TextStyle(fontSize: 18),),
                  space(10),
                  Pinput(controller: _pinputController,length: 6,),
                  space(10),
                  Row(children: [
                    Expanded(child: ElevatedButton(onPressed: _verifyOTP, child: const Text('Verify')))
                  ],)
                ],
              ),
            ),
          ),
        ),
      );
    },);
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Easy PG'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric( horizontal:  12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CountryCodePicker(
                      onChanged: (value) => countryCode = value.code ?? countryCode,
                      initialSelection: countryCode,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoNoController,
                        decoration:
                            const InputDecoration(hintText: 'Enter Phone Number:'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              space(40),
              Row(
                children: [
                  Expanded(

                      child: ElevatedButton(

                          onPressed: _manageLogin, child: const Text("Login"))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
