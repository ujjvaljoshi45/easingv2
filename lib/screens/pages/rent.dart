import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/screens/add_property/add_property_page.dart';
import 'package:easypg/screens/widgets/property_card.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class RentPage extends StatefulWidget {
  const RentPage({super.key});

  @override
  State<RentPage> createState() => _RentPageState();
}

class _RentPageState extends State<RentPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiHandler.instance.getPropertiesById(true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: myOrange,
          ));
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('No Data Found!'),
          );
        }
        if (snapshot.requireData.isEmpty || !snapshot.hasData) {
          return Column(
            children: [
              space(50),
              Text(
                'List Your Property\nAnd\nEnjoy Passive Income',
                style: montserrat.copyWith(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Extra Income, Effortless',
                  style: montserrat.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(myOrange),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)))),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddPropertyPage(),
                              )),
                          child: Text(
                            'Click Here',
                            style: montserrat.copyWith(
                                color: white, fontWeight: FontWeight.bold, fontSize: 20),
                          )))
                ],
              ),
              space(10),
            ],
          );
        }
        List<Property> properties = snapshot.requireData;
        logEvent(snapshot.requireData.length);
        return snapshot.requireData.isEmpty
            ? const Center(
                child: Text('Empty!'),
              )
            : ListView.builder(
                itemBuilder: (context, index) => Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: properties[index].status ? Colors.green : Colors.red),
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 1.3,
                  shadowColor: properties[index].status ? Colors.green : Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(
                        leading: Text(
                          properties[index].status ? 'Active' : 'Not Active',
                          style: montserrat.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: properties[index].status ? Colors.green : Colors.red),
                        ),
                        trailing: !properties[index].status
                            ? ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(myOrangeSecondary),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () async => await _managePayment(properties[index]),
                                child: Text(
                                  "Activate",
                                  style: montserrat.copyWith(
                                    color: myOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PropertyCard(property: properties[index], topWidget: 'delete'),
                      ),
                    ],
                  ),
                ),
                itemCount: properties.length,
              );
      },
    );
  }

  Future<void> _managePayment(Property property) async {
    final response = await AllInOneSdk.startTransaction(
        'ujjval',
        "${property.id}@${DateTime.now().millisecondsSinceEpoch}",
        '100.00',
        'myToken',
        'https:localhost:3000',
        kDebugMode,
        false);
    logEvent('res: $response');
  }
}
