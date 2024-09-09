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
  String propertyTypeFilter = 'House';

  _changePropertyType(String value) {
    logEvent('CPT $propertyTypeFilter');
    setState(()=>propertyTypeFilter=value);
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height:
            getHeight(context) - kBottomNavigationBarHeight - kToolbarHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'Grab The',
                      style: montserrat.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: black)),
                  TextSpan(
                    text: ' Best ',
                    style: montserrat.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: myOrange),
                  ),
                  TextSpan(
                      text: 'Deals',
                      style: montserrat.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: black)),
                ],
              ),
            ),
            SearchCard(changePropertyType: _changePropertyType,selectedPropertyType: propertyTypeFilter,),
          ],
        ),
      ),
    );
  }
}

class SearchCard extends StatefulWidget {
  const SearchCard({super.key, required this.changePropertyType, required this.selectedPropertyType});
  final Function(String) changePropertyType;
  final String selectedPropertyType;
  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  late String selectedPropertyType;
  @override
  void initState() {
    selectedPropertyType = widget.selectedPropertyType;
    super.initState();
  }
  List<String> types = ['House','Pg/Hostel','Apartment','Duplex'];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(onPressed: (){}, label: Text('Get Location'),icon: Image.asset('assets/location.png'),)
                // Icon(Icons.location_on),
                // SizedBox(width: 8.0),
                // Flexible(child: TextField(enabled: false,)),
              ],
            ),
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              children: [
                for (String str in types)
                Expanded(
                  child: PropertyTypeButton(onPressed: () {
                    logEvent('Base $str');
                    setState(() => selectedPropertyType=str);
                    widget.changePropertyType(str);},isSelected: selectedPropertyType == str,text: str,),
                ),
                // PropertyTypeButton(onPressed: () => widget.changePropertyType('Pg/Hostel'),isSelected: false,text: 'Pg/Hostel',),
                // PropertyTypeButton(onPressed: () => widget.changePropertyType('Apartment'),isSelected: false,text: 'Apartment',),
                // PropertyTypeButton(onPressed: () => widget.changePropertyType('Duplex'),isSelected: false,text: 'Duplex',),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement search functionality here
                      print("Searching for $selectedPropertyType in Ahmedabad, Guj, India");
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    ),
                    child: const Text("Search"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyTypeButton extends StatelessWidget {
  const PropertyTypeButton(
      {super.key,
        required this.isSelected,
        required this.text,
        required this.onPressed});
  final bool isSelected;
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style:
      isSelected ? selectedPropertyTypeButtonStyle : unSelectedPropertyTypeButtonStyle,
      child: Text(
        text,
        style: isSelected ? selectedPropertyTypeTextStyle : unSelectedPropertyTypeTextStyle,
      ),
    );
  }
}
