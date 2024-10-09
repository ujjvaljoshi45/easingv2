import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/screens/home_screen.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  static String route = 'register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  String gender = 'male';
  bool isLoading = false;

  _manageRegister() async {
    if (_nameController.text.length < 3) return;
    AppUser appUser = DataProvider.instance.getUser;
    appUser.displayName = _nameController.text;
    appUser.gender = gender;
    setState(()=>isLoading=true);
    await ApiHandler.instance.saveUser(appUser);
    await FirebaseAuth.instance.currentUser!.updateDisplayName(_nameController.text);
    setState(()=>isLoading=false);
    mounted ? DataProvider.instance.setUser(appUser) : null;
    mounted ? Navigator.pushNamed(context, HomeScreen.route) : null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/login_vector.png'),
                    Text('Welcome!',
                        style: montserrat.copyWith(
                          color: myOrange,
                          fontSize: 22.0.sp,
                          fontWeight: FontWeight.bold,
                        )),
                    space(20),
                    Container(
                      height: 70.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadiusDirectional.circular(10.r)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: TextField(
                            cursorColor: myOrange,
                            controller: _nameController,
                            decoration: InputDecoration(
                              focusColor: myOrange,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: myOrange,
                                      style: BorderStyle.none,
                                      strokeAlign: BorderSide.strokeAlignOutside,
                                      width: 2.w)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: myOrange,
                                      style: BorderStyle.none,
                                      strokeAlign: BorderSide.strokeAlignOutside,
                                      width: 2.w)),
                              labelText: 'Name',
                              labelStyle:
                                  montserrat.copyWith(fontWeight: FontWeight.w500, color: myOrange),
                            ),
                          ),
                        ),
                      ),
                    ),
                    space(20),
                    Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadiusDirectional.circular(10.r)),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: DropdownMenu(
                          initialSelection: gender,
                          label: Text(
                            'Gender',
                            style: montserrat.copyWith(fontWeight: FontWeight.w500, color: myOrange),
                          ),
                          onSelected: (value) => setState(() => gender = value ?? gender),
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(
                              label: 'Male',
                              value: 'male',
                            ),
                            DropdownMenuEntry(
                              label: 'Female',
                              value: 'female',
                            )
                          ],
                          inputDecorationTheme: InputDecorationTheme(
                            focusColor: myOrange,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: myOrange,
                                    style: BorderStyle.none,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    width: 2.w)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: myOrange,
                                    style: BorderStyle.none,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    width: 2.w)),
                          ),
                        ),
                      ),
                    ),
                    space(20),
                    InkWell(
                      onTap: _manageRegister,
                      child: Container(
                        height: 70.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: myOrange,
                          borderRadius: BorderRadiusDirectional.circular(10.r),
                        ),
                        child:  Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: isLoading ? CircularProgressIndicator(color: myOrangeSecondary,) :  Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
