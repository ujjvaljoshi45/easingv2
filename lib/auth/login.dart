import 'package:easypg/provider/auth_provider.dart';
import 'package:easypg/services/app_configs.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static String route = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode phoneFocusNode = FocusNode();
  PhoneNumber phoneNumber = PhoneNumber();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
            child: SingleChildScrollView(
              reverse: true,
              child: SizedBox(
                height: getHeight(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    space(kToolbarHeight.h),
                    const Spacer(),
                    Image.asset('assets/login_vector.png'),
                    const Spacer(),
                    FractionallySizedBox(widthFactor: 0.9.w, child: _buildPhoneInputField()),
                    space(40),
                    _buildSubmitButton(),
                    TextButton(
                      onPressed: () async =>
                          await manageUrl(await AppConfigs.instance.getTermsLink()),
                      child: Text(
                        'Terms Of Service',
                        style: unSelectedOptionTextStyle.copyWith(
                            color: myOrange, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInputField() {
    return InternationalPhoneNumberInput(
      initialValue: PhoneNumber(isoCode: 'IN', phoneNumber: ''),
      ignoreBlank: false,
      maxLength: 12,
      focusNode: phoneFocusNode,
      selectorTextStyle: montserrat.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      keyboardType: TextInputType.number,
      textStyle: montserrat.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      inputDecoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
      ),
      countrySelectorScrollControlled: true,
      selectorConfig: const SelectorConfig(
        showFlags: true,
        trailingSpace: false,
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        leadingPadding: 12.0,
        useBottomSheetSafeArea: true,
        setSelectorButtonAsPrefixIcon: true,
      ),
      onInputChanged: (value) => phoneNumber = value,
    );
  }

  _buildSubmitButton() {
    return Consumer<AuthDataProvider>(
      builder: (context, authProvider, child) {
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: authProvider.isLoading ? null : _manageLogin,
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 15),
                  ),
                  backgroundColor: WidgetStateProperty.all(
                    authProvider.isLoading
                        ? Colors.grey
                        : myOrange, // Change button color when loading
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ), // Disable button when loading
                child: Text(
                  'SEND OTP',
                  style: GoogleFonts.montserrat(
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _manageLogin() async {
    phoneFocusNode.unfocus();
    final authProvider = AuthDataProvider.instance;
    String? phNo = phoneNumber.phoneNumber;
    String? code = phoneNumber.dialCode;
    logEvent('login $phNo $code');
    if (phNo == null || code == null || phNo.length < 12 || code.isEmpty) {
      logEvent('its empty');
      return;
    } else {
      await authProvider.requestOtp(
        phNo,
        context,
      );
    }
  }
}
