import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/screens/add_property/2_add_location.dart';
import 'package:easypg/screens/add_property/5_add_photo.dart';
import 'package:easypg/screens/add_property/4_amenities_information.dart';
import 'package:easypg/screens/add_property/1_getting_started_page.dart';
import 'package:easypg/screens/add_property/3_other_information.dart';
import 'package:easypg/screens/add_property/widgets/save_and_next_btn.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({super.key});

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final PageController _pageController = PageController();
  final List<String> _appBarTitle = [
    'Let’s get you started',
    'Property Location',
    'Relevant Information',
    'Additional Information',
    'Add Photos',
  ];
  int _currentIndex = 0;
  final int _totalLength = 4;

  _handelPageChangeChange() {
    if (_currentIndex < _totalLength) {
      _currentIndex++;
      debugPrint("cIndex:$_currentIndex");
      _pageController.animateToPage(_currentIndex,
          curve: Curves.linearToEaseOut,
          duration: const Duration(milliseconds: 100));
      setState(() {});
    } else {
      showToast('end', null);
      return;
    }
  }

  _manageBack() {
    debugPrint("clicked : $_currentIndex");
    if (_currentIndex <= 0) {
      AddPropertyProvider.instance.clear();
      Navigator.pop(context);
    } else {
      _currentIndex--;
      _pageController.animateToPage(_currentIndex,
          curve: Curves.linearToEaseOut,
          duration: const Duration(milliseconds: 250));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: black,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: _manageBack,
          icon: Icon(
            Icons.arrow_back,
            color: white,
          ),
        ),
        iconTheme: IconThemeData(
          color: white,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r))),
        title: Text(
          _appBarTitle[_currentIndex],
          style: montserrat.copyWith(
              fontSize: 20.sp, fontWeight: FontWeight.bold, color: white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            GettingStartedPage(
              handelPageChange: () => _handelPageChangeChange(),
            ),
            AddLocationPage(
              handelPageChange: () => _handelPageChangeChange(),
            ),
            OtherInformationPage(
                handelPageChange: () => _handelPageChangeChange()),
            AdditionInformationPage(
                handelPageChange: () => _handelPageChangeChange()),
            AddPhotoPage(handelPageChange: () => _handelPageChangeChange()),
          ],
        ),
      ),
      bottomNavigationBar: SaveAndNextBtn(
          onPressed: _handelPageChangeChange, msg: 'Save And Next'),
    );
  }
}
