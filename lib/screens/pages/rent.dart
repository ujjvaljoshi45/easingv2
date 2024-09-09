import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/add_property/add_property_page.dart';
import 'package:easypg/screens/widgets/property_card.dart';
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
          children: DataProvider.instance.getUser.myProperties.isNotEmpty ? [
            RichText(text: TextSpan(children: [
              TextSpan(text: 'Your',style: montserrat.copyWith(fontSize: 24,fontWeight: FontWeight.bold,color: black)),
              TextSpan(text: ' Properties', style: montserrat.copyWith(fontSize: 24,fontWeight: FontWeight.bold,color: myOrange),),
            ])),
            space(20),
            // const HouseCard(),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: getHeight(context) - kBottomNavigationBarHeight - kToolbarHeight - getHeight(context)*0.2 - 10),
              child: FutureBuilder(future: ApiHandler.instance.getPropertiesById(true), builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: myOrange,));
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text('No Data Found!'),);
                }
                List<Property> properties = snapshot.requireData;
                return snapshot.requireData.isEmpty ? const Center(child: Text('Empty!'),) : ListView.builder(itemBuilder: (context, index) => PropertyCard(property: properties[index],),itemCount: properties.length,);
              },),),
            space(10)
          ] : [
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
