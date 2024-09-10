import 'package:easypg/provider/auh_provider.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OptInputScreen extends StatefulWidget {
  final String phoneNumber;

  const OptInputScreen({super.key, required this.phoneNumber});

  @override
  State<OptInputScreen> createState() => _OptInputScreenState();
}

class _OptInputScreenState extends State<OptInputScreen> {
  String otp = '';
  @override
  Widget build(BuildContext context) {
    final authProvider = AuthProvider.instance;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Center(
          child: SingleChildScrollView(
            reverse: false,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Verify your\nPhone Number",
                    // style: AppTextStyles.kOnboardingTitleTextStyle
                    //     .copyWith(color: AppColors.kDarkColor),
                    textAlign: TextAlign.center,
                  ),
                  const Text("Enter your OTP code here.",
                      // style: AppTextStyles.kOnboardingSubtitleTextStyle,
                      textAlign: TextAlign.center),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Pinput(
                      length: 6,
                      defaultPinTheme: PinTheme(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: myOrange,
                            shape: BoxShape.circle,
                          ),
                          textStyle:
                          montserrat.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          )),
                      submittedPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: myOrange,
                          shape: BoxShape.circle,
                        ),
                        // textStyle: AppTextStyles.kPhoneInputTextFieldTextStyle
                        //     .copyWith(color: Colors.white),
                      ),
                      onChanged: (value) {
                        otp = value;
                        if (value.length == 6) {
                          //TODO: Run method to verify otp here
                          authProvider.verifyOtp(
                            otp,
                            context,
                            widget.phoneNumber,
                          );
                        }
                      },
                      onSubmitted: (value) {
                        //TODO: Run method to verify otp here too
                        // Verify OTP
                        authProvider.verifyOtp(
                          otp,
                          context,
                          widget.phoneNumber,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text("Didn't receive any code?",
                      // style: AppTextStyles.kOnboardingSubtitleTextStyle,
                      textAlign: TextAlign.center),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "RESEND CODE",
                        style: montserrat.copyWith(
                          letterSpacing: 1.5,
                          color: myOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
