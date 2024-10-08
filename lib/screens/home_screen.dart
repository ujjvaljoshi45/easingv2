import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/model/user.dart';
import 'package:easypg/screens/add_property/add_property_page.dart';
import 'package:easypg/screens/pages/bookmarks.dart';
import 'package:easypg/screens/pages/home.dart';
import 'package:easypg/screens/pages/profile/profile.dart';
import 'package:easypg/screens/pages/rent.dart';
import 'package:easypg/screens/pages/search.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          bottomNavigationBar: BottomBarInspiredOutside(
            items: const [
              TabItem(
                icon: FontAwesomeIcons.house,
                title: 'Home',
              ),
              TabItem(icon: FontAwesomeIcons.magnifyingGlassLocation, title: 'Search'),
              TabItem(icon: FontAwesomeIcons.solidBookmark, title: 'Bookmarks'),
              TabItem(icon: FontAwesomeIcons.solidSquarePlus, title: 'Rent'),
            ],
            titleStyle:
                montserrat.copyWith(color: myOrange, fontWeight: FontWeight.bold, fontSize: 10),
            curve: Curves.easeIn,
            radius: 24,
            duration: const Duration(milliseconds: 200),
            backgroundColor: Colors.black,
            color: myOrangeSecondary,
            colorSelected: myOrangeSecondary,
            isAnimated: true,
            chipStyle: ChipStyle(
              notchSmoothness: NotchSmoothness.softEdge,
              background: myOrange,
            ),
            itemStyle: ItemStyle.circle,
            indexSelected: _currentIndex,
            animated: true,
            elevation: 2,
            onTap: _handelPageChange,
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Visibility(
              visible: _currentIndex == titleWidget.length - 1 &&
                  DataProvider.instance.getUser.myProperties.isNotEmpty,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: myOrange,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPropertyPage(),
                    )),
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  color: myOrangeSecondary,
                ),
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
                          onTap: () => Navigator.pushNamed(context, ProfileScreen.route),
                          child: DottedBorder(
                            borderType: BorderType.Circle,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundImage: DataProvider.instance.getUser.profileUrl.isEmpty
                                  ? const AssetImage('assets/user_icon.png')
                                  : CachedNetworkImageProvider(
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
