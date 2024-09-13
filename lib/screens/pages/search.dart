import 'package:easypg/model/property.dart';
import 'package:easypg/screens/add_property/option_elevated_button.dart';
import 'package:easypg/screens/widgets/property_card.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> searchCategory = ['House', 'Pg/Hostel', 'Apartment', 'Duplex'];
  int _currentSelection = -1;
  List<Property> properties = [];
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  selected: true,
                  selectedTileColor: const Color.fromRGBO(234, 234, 234, 1),
                  leading: const Icon(
                    Icons.my_location_rounded,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Some Location',
                    style: montserrat.copyWith(fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                ),
                space(15),
                Row(
                  children: [
                    for (int i = 0; i < searchCategory.length / 2; i++)
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: OptionElevatedButton(
                          isSelected: _currentSelection == i,
                          text: searchCategory[i],
                          onPressed: () => setState(() => _currentSelection = i),
                          color: myOrange,
                        ),
                      ))
                  ],
                ),
                space(10),
                Row(
                  children: [
                    for (int i = searchCategory.length ~/ 2; i < searchCategory.length; i++)
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: OptionElevatedButton(
                          isSelected: _currentSelection == i,
                          text: searchCategory[i],
                          onPressed: () => setState(() => _currentSelection = i),
                          color: myOrange,
                        ),
                      ))
                  ],
                ),
                space(15),
                ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(Colors.black),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        fixedSize: WidgetStatePropertyAll(Size(getWidth(context), 50))),
                    child: Text(
                      "Search",
                      style: montserrat.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            ),
          ),
        ),
        Flexible(
          child: properties.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Empty")],
                  ),
                )
              : ListView.builder(
            controller: scrollController,
                  itemBuilder: (context, index) => PropertyCard(
                    property: properties[index],
                  ),
                  itemCount: properties.length,
                ),
        )
      ],
    );
  }
}
