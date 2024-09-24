import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/add_property/add_property_page.dart';
import 'package:easypg/screens/widgets/property_card.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RentPage extends StatefulWidget {
  const RentPage({super.key});

  @override
  State<RentPage> createState() => _RentPageState();
}

class _RentPageState extends State<RentPage> {
  _handelDelete(Property property) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Property.'),
          content: const Text("Are you sure you want to delete property\nThis Won't be undone!"),
          actions: [
            TextButton(
                onPressed: () async => await ApiHandler.instance
                    .deleteProperty(property.id)
                    .whenComplete(
                      () => setState(() {
                        DataProvider.instance.getUser.myProperties.removeWhere(
                          (element) => element == property.id,
                        );
                        Navigator.pop(context);
                      }),
                    )
                    .onError(
                      (error, stackTrace) => setState(() {
                        logError('deleteError', error, stackTrace);
                        Navigator.pop(context);
                      }),
                    ),
                child: Text(
                  "YES",
                  style: montserrat.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18),
                )),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "NO",
                  style: montserrat.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 18),
                ))
          ],
        );
      },
    );
  }

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
          itemBuilder: (context, index) => PropertyCard(
            property: properties[index],
            topWidget: {
              'callback': () {
                Fluttertoast.showToast(
                  msg: 'hi',
                );
              },
              'widget': FloatingActionButton.small(
                onPressed: () => _handelDelete(properties[index]),
                backgroundColor: Colors.black,
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              )
            },
          ),
          itemCount: properties.length,
        );
      },
    );
  }
}
