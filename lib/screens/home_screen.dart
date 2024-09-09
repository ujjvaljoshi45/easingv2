import 'package:easypg/model/data_provider.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/screens/pages/bookmarks.dart';
import 'package:easypg/screens/pages/home.dart';
import 'package:easypg/screens/pages/rent.dart';
import 'package:easypg/screens/pages/search.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String route = 'home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late AppUser appUser;
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  @override
  void initState() {
    appUser = DataProvider.instance.getUser;
    super.initState();
  }

  void _handelPageChange(value) => setState(() {
    _currentIndex=value;
    _pageController.jumpToPage(_currentIndex);
  });
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(


        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _handelPageChange,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          unselectedItemColor: white,
          selectedItemColor: myOrange,
          selectedLabelStyle: montserrat.copyWith(color: white,fontWeight: FontWeight.bold),
          unselectedLabelStyle: montserrat.copyWith(color: white,fontWeight: FontWeight.bold),
          iconSize: 20,
          items: [
            BottomNavigationBarItem(icon: Image.asset('assets/home.png',color: _currentIndex == 0 ? myOrange : white ,),label: 'Home'),
            BottomNavigationBarItem(icon: Image.asset('assets/search.png',color: _currentIndex == 1 ? myOrange : white),label: 'Search'),
            BottomNavigationBarItem(icon: Image.asset('assets/bookmarks.png',color: _currentIndex == 2 ? myOrange : white),label: 'Bookmarks'),
            BottomNavigationBarItem(icon: Image.asset('assets/rent.png',color: _currentIndex == 3 ? myOrange : white),label: 'Rent'),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric( horizontal:  18.0),
            child: Column(
              children: [
                space(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  IconButton(icon: Image.asset('assets/burger.png',height: 48,width: 48,),onPressed: (){},),
                  InkWell(
                    onTap: (){},
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage('assets/pf.jpg'),
                    ),
                  ),
                ],),
                space(20),
                Flexible(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: _handelPageChange,
                  
                    children: const [
                      HomePage(),
                      SearchPage(),
                      BookmarksPage(),
                      RentPage(),
                    ],
                  ),
                ),
              ],
            )
          ),
        )
      ),
    );
  }
}
