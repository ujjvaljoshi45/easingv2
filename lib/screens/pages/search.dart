import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/api_handler/firebase_controller.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/screens/add_property/option_elevated_button.dart';
import 'package:easypg/screens/pages/places_api.dart';
import 'package:easypg/screens/widgets/property_card.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final TextEditingController _queryController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  _queryDatabase() async {
    final String? propertyType = _currentSelection > -1 ? searchCategory[_currentSelection] : null;
    final myQuery = _queryController.text;
    properties = await ApiHandler.instance.queryProperties(myQuery, propertyType);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _focusNode.unfocus(),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        title: TextFormField(
                          controller: _queryController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.transparent),
                            ),
                            fillColor: const Color.fromRGBO(234, 234, 234, 1),
                            filled: true,
                            hintText: 'Search...',
                            hintStyle: montserrat.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.my_location_rounded,
                              color: Colors.black,
                            ),
                          ),
                        )),
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
                                  onPressed: () => setState(() =>
                                  _currentSelection == i
                                      ? _currentSelection = -1
                                      : _currentSelection = i),
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
                                  onPressed: () => setState(() =>
                                  _currentSelection == i
                                      ? _currentSelection = -1
                                      : _currentSelection = i),
                                  color: myOrange,
                                ),
                              ))
                      ],
                    ),
                    space(15),
                    ElevatedButton(
                        onPressed: _queryDatabase,
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
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => PropertyCard(
                property: properties[index],
              ),
              childCount: properties.length,
            ),
          ),
        ],
      ),
    );
  }
}
