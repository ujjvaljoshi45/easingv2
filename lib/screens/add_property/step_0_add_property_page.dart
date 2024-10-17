import 'package:easypg/model/property.dart';
import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/add_property/step_2_add_location.dart';
import 'package:easypg/screens/add_property/step_5_add_photo.dart';
import 'package:easypg/screens/add_property/step_4_amenities_information.dart';
import 'package:easypg/screens/add_property/step_1_getting_started_page.dart';
import 'package:easypg/screens/add_property/step_3_other_information.dart';
import 'package:easypg/screens/add_property/step_6_overview.dart';
import 'package:easypg/screens/add_property/widgets/save_and_next_btn.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({super.key, this.property});
  final Property? property;

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  @override
  void initState() {
    AddPropertyProvider.instance.property.uploaderId = DataProvider.instance.getUser.uid;
    if (widget.property != null) AddPropertyProvider.instance.property=widget.property!;
    super.initState();
  }

  final FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Consumer<AddPropertyProvider>(
      builder: (context, myProvider, child) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: black,
              automaticallyImplyLeading: true,
              leading: IconButton(
                  onPressed: () => myProvider.manageBack(context),
                  icon: FaIcon(FontAwesomeIcons.arrowLeft)),
              iconTheme: IconThemeData(
                color: white,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24.r), bottomRight: Radius.circular(24.r))),
              title: Text(
                myProvider.appBarTitle[myProvider.currentIndex],
                style:
                    montserrat.copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold, color: white),
              ),
            ),
            body: SingleChildScrollView(
              reverse: true,
              child: SizedBox(
                height: getHeight(context) - kToolbarHeight.h - kBottomNavigationBarHeight.h,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: myProvider.pageController,
                    children: [
                      GettingStartedPage(),
                      AddLocationPage(),
                      OtherInformationPage(),
                      AddAmenitiesPage(),
                      AddPhotoPage(),
                      OverviewScreen(),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SaveAndNextBtn(
                  onPressed: () => myProvider.handelPageChangeChange(context),
                  msg: myProvider.currentIndex < myProvider.totalLength
                      ? 'Save And Next'
                      : 'Publish'),
            ),
          ),
        );
      },
    );
  }
}
