import 'package:easypg/provider/auth_provider.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

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
    final authProvider = AuthDataProvider.instance;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Center(
          child: Provider.of<AuthDataProvider>(context).isOtpLoading
              ? CircularProgressIndicator(
                  color: myOrange,
                )
              : SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Verify your\nPhone Number",
                          style: montserrat.copyWith(
                            color: myOrange,
                            fontSize: 22.0.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text("Enter your OTP code here.",
                            style: montserrat.copyWith(
                              color: Colors.black38,
                              fontSize: 18.0.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center),
                        space(40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Pinput(
                            length: 6,
                            defaultPinTheme: PinTheme(
                                width: 50.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: myOrange,
                                  shape: BoxShape.circle,
                                ),
                                textStyle: montserrat.copyWith(
                                  color: myOrangeSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                )),
                            submittedPinTheme: PinTheme(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                color: myOrange,
                                shape: BoxShape.circle,
                              ),
                              textStyle: montserrat.copyWith(
                                color: myOrangeSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onChanged: (value) {
                              otp = value;
                              if (value.length == 6) {
                                authProvider.verifyOtp(
                                  otp,
                                  context,
                                  widget.phoneNumber,
                                );
                              }
                            },
                            onSubmitted: (value) {
                              authProvider.verifyOtp(
                                otp,
                                context,
                                widget.phoneNumber,
                              );
                            },
                          ),
                        ),
                        space(40),
                        Text("Didn't receive any code?",
                            style: montserrat.copyWith(
                              color: Colors.black38,
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center),
                        TextButton(
                            onPressed: () {
                              AuthDataProvider.instance.phoneNumber == null
                                  ? Navigator.pop(context)
                                  : AuthDataProvider.instance
                                      .requestOtp(AuthDataProvider.instance.phoneNumber!, context);
                            },
                            child: Text(
                              "RESEND CODE",
                              style: montserrat.copyWith(
                                letterSpacing: 1.5,
                                color: myOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
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
