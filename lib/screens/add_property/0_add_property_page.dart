import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/screens/add_property/2_add_location.dart';
import 'package:easypg/screens/add_property/5_add_photo.dart';
import 'package:easypg/screens/add_property/4_amenities_information.dart';
import 'package:easypg/screens/add_property/1_getting_started_page.dart';
import 'package:easypg/screens/add_property/3_other_information.dart';
import 'package:easypg/screens/add_property/widgets/save_and_next_btn.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({super.key});

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: black,
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () => AddPropertyProvider.instance.manageBack(context),
            icon: FaIcon(FontAwesomeIcons.arrowLeft)),
        iconTheme: IconThemeData(
          color: white,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r))),
        title: Text(
          AddPropertyProvider
              .instance.appBarTitle[AddPropertyProvider.instance.currentIndex],
          style: montserrat.copyWith(
              fontSize: 20.sp, fontWeight: FontWeight.bold, color: white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: AddPropertyProvider.instance.pageController,
          children: [
            GettingStartedPage(
              handelPageChange: () =>
                  AddPropertyProvider.instance.handelPageChangeChange(),
            ),
            AddLocationPage(
              handelPageChange: () =>
                  AddPropertyProvider.instance.handelPageChangeChange(),
            ),
            OtherInformationPage(
                handelPageChange: () =>
                    AddPropertyProvider.instance.handelPageChangeChange()),
            AddAmenitiesPage(
                handelPageChange: () =>
                    AddPropertyProvider.instance.handelPageChangeChange()),
            AddPhotoPage(
                handelPageChange: () =>
                    AddPropertyProvider.instance.handelPageChangeChange()),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SaveAndNextBtn(
            onPressed: AddPropertyProvider.instance.handelPageChangeChange,
            msg: 'Save And Next'),
      ),
    );
  }
}
