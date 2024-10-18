import 'package:easypg/services/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/screens/add_property/widgets/option_elevated_button.dart';
import 'package:easypg/screens/widgets/property_card.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    _focusNode.unfocus();
    final String? propertyType = _currentSelection > -1 ? searchCategory[_currentSelection] : null;
    final myQuery = _queryController.text;
    properties = await ApiHandler.instance.queryProperties(myQuery.toLowerCase(), propertyType);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async => Future.delayed(Duration(milliseconds: 200)).whenComplete(
        () => setState(() {}),
      ),
      backgroundColor: myOrangeSecondary,
      color: myOrange,
      strokeWidth: 2.5.w,
      child: GestureDetector(
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
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(color: Colors.transparent),
                              ),
                              fillColor: const Color.fromRGBO(234, 234, 234, 1),
                              filled: true,
                              hintText: 'Search...',
                              hintStyle: montserrat.copyWith(
                                  fontWeight: FontWeight.w600, color: Colors.black),
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
                                onPressed: () => setState(() => _currentSelection == i
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
                                onPressed: () => setState(() => _currentSelection == i
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
                              // splashFactory: InkSplash.splashFactory,
                              overlayColor: const WidgetStatePropertyAll(Colors.grey),
                              backgroundColor: const WidgetStatePropertyAll(Colors.black),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              fixedSize: WidgetStatePropertyAll(Size(getWidth(context), 50.h))),
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
            SliverToBoxAdapter(
              child: Visibility(
                visible: properties.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                  child: Text(
                    'Result',
                    style: montserrat.copyWith(fontSize: 24.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => PropertyCard(
                  property: properties[index],
                  topWidget: 'bookmark',
                ),
                childCount: properties.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
