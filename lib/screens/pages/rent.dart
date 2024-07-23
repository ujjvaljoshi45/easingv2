import 'package:easypg/screens/add_property/add_property_page.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';

class RentPage extends StatelessWidget {
  const RentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            kToolbarHeight -
            80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            space(50),
            Text(
              'List Your Property\nAnd\nEnjoy Passive Income',
              style: montserrat.copyWith(
                  fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Extra Income, Effortless',
                style: montserrat.copyWith(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(myOrange),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12.0)))),
                        onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const AddPropertyPage(),)),
                        child: Text(
                          'Click Here',
                          style: montserrat.copyWith(
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )))
              ],
            ),
            space(10),
          ],
        ),
      ),
    );
  }
}
