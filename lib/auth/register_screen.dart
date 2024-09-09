import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/data_provider.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/screens/home_screen.dart';
import 'package:easypg/utils/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class RegisterScreen extends StatefulWidget {
  static String route = 'register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String name = '';
  String gender = 'male';

  _manageRegister() async {
    if (name.length < 3) return;
    AppUser appUser = DataProvider.instance.getUser;
    appUser.displayName = name;
    appUser.gender = gender;
    await ApiHandler.instance.saveUser(appUser);
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    mounted ? DataProvider.instance.setUser(appUser) : null;
    mounted ? Navigator.pushNamed(context, HomeScreen.route) : null;
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(

        body:  SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only( bottom:  MediaQuery.viewInsetsOf(context).bottom),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Padding(
                padding: const EdgeInsets.symmetric( horizontal:  12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Welcome!',style: TextStyle(fontSize: 24),),
                    space(20),
                     TextField(
                    onChanged: (value) => setState(()=>name=value),
                      decoration: const InputDecoration(
                        labelText: 'Enter Your Name'
                      ),
                    ),
                    space(20),
                    DropdownMenu( initialSelection: gender,
                        label : const Text('Gender'),
                        onSelected: (value) => setState(()=>gender = value ?? gender)
                        ,
                        dropdownMenuEntries: const [DropdownMenuEntry(label: 'Male',value: 'male',),DropdownMenuEntry(label: 'Female',value: 'female',)]),
                    space(20),
                    Row(
                      children: [
                        Expanded(child: ElevatedButton(onPressed: _manageRegister, child: const Text('Register'),)),
                      ],
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
