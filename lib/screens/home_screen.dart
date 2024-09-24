import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easypg/auth/login.dart';
import 'package:easypg/model/cache_manager.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/screens/add_property/add_property_page.dart';
import 'package:easypg/screens/pages/bookmarks.dart';
import 'package:easypg/screens/pages/home.dart';
import 'package:easypg/screens/pages/rent.dart';
import 'package:easypg/screens/pages/search.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<Widget> titleWidget = [
    RichText(
        text: TextSpan(children: [
      TextSpan(
          text: 'Find Your',
          style: montserrat.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: black)),
      TextSpan(
        text: ' Dream',
        style: montserrat.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: myOrange),
      ),
      TextSpan(
          text: '\nHome Today',
          style: montserrat.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: black)),
    ])),
    RichText(
        text: TextSpan(children: [
      TextSpan(
        text: 'Search',
        style: montserrat.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: myOrange),
      ),
    ])),
    RichText(
        text: TextSpan(children: [
      TextSpan(
        text: 'Bookmarks',
        style: montserrat.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: myOrange),
      ),
    ])),
    RichText(
        text: TextSpan(children: [
      TextSpan(
          text: 'Your',
          style: montserrat.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: black)),
      TextSpan(
        text: ' Properties',
        style: montserrat.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: myOrange),
      ),
    ])),
  ];
  @override
  void initState() {
    appUser = DataProvider.instance.getUser;
    super.initState();
  }

  void _handelPageChange(value) => setState(() {
        _currentIndex = value;
        _pageController.jumpToPage(_currentIndex);
      });
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          bottomNavigationBar: Container(
            margin: const EdgeInsets.only(bottom: 6, left: 12, right: 12),
            decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(12)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _handelPageChange,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.black,
                showUnselectedLabels: true,
                showSelectedLabels: true,
                unselectedItemColor: white,
                selectedItemColor: myOrange,
                selectedLabelStyle: montserrat.copyWith(color: white, fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                    montserrat.copyWith(color: white, fontWeight: FontWeight.bold),
                iconSize: 20,
                items: [
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/home.png',
                        color: _currentIndex == 0 ? myOrange : white,
                      ),
                      label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Image.asset('assets/search.png',
                          color: _currentIndex == 1 ? myOrange : white),
                      label: 'Search'),
                  BottomNavigationBarItem(
                      icon: Image.asset('assets/bookmarks.png',
                          color: _currentIndex == 2 ? myOrange : white),
                      label: 'Bookmarks'),
                  BottomNavigationBarItem(
                      icon: Image.asset('assets/rent.png',
                          color: _currentIndex == 3 ? myOrange : white),
                      label: 'Rent'),
                ],
              ),
            ),
          ),
          floatingActionButton: Visibility(
            visible: _currentIndex == titleWidget.length - 1 && DataProvider.instance.getUser.myProperties.isNotEmpty,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: myOrange,
              onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPropertyPage(),
              )),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    space(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: titleWidget[_currentIndex]),
                        InkWell(
                          onTap: () async {
                            CacheManager.user = null;
                            await FirebaseAuth.instance.signOut();
                            mounted
                                ? Navigator.pushReplacementNamed(context, LoginScreen.route)
                                : null;
                          },
                          child: DottedBorder(
                            borderType: BorderType.Circle,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundImage: DataProvider.instance.getUser.profileUrl.isEmpty ?  const AssetImage('assets/user_icon.png') : CachedNetworkImageProvider(
            
                                DataProvider.instance.getUser.profileUrl,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    space(20),
                    Expanded(
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
                )),
          )),
    );
  }
}
