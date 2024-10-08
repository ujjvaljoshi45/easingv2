import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easypg/model/api_handler/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/add_property/save_and_next_btn.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PropertyCard extends StatefulWidget {
  const PropertyCard({super.key, required this.property, this.topWidget});
  final Property property;
  final String? topWidget;

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  final Duration _pageChangeDuration = const Duration(milliseconds: 150);
  int _currentPhotoIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4,
        child: ExpansionTile(
          initiallyExpanded: false,
          showTrailingIcon: false,
          shape:
              const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
          title: _buildTitleWidget(),
          subtitle: _buildSubTitleWidget(),
          children: _buildChildren(),
        ),
      ),
    );
  }

  _buildTitleWidget() => Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: CarouselSlider.builder(
              itemCount: widget.property.photos.length,
              itemBuilder: (context, index, realIndex) => CachedNetworkImage(
                imageUrl: widget.property.photos[index],
                width: double.infinity,
                fit: BoxFit.fitHeight,
              ),
              options: CarouselOptions(
                  autoPlay: false,
                  autoPlayAnimationDuration: _pageChangeDuration,
                  onPageChanged: (index, reason) => setState(
                        () => _currentPhotoIndex = index,
                      ),
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  aspectRatio: 16 / 9,
                  height: 250),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: myOrangeSecondary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                widget.property.propertyType,
                style: montserrat.copyWith(
                  color: myOrange,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: widget.topWidget != null
                ? _buildTopWidget(widget.topWidget!)
                : const SizedBox.shrink(),
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), color: Colors.black.withOpacity(0.2)),
                child: Row(
                  children: [
                    for (int i = 0; i < widget.property.photos.length; i++)
                      AnimatedContainer(
                        duration: _pageChangeDuration,
                        curve: Curves.decelerate,
                        margin: const EdgeInsets.all(2.0),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _currentPhotoIndex ? myOrange : myOrangeSecondary),
                      )
                  ],
                ),
              ))
        ],
      );

  _buildSubTitleWidget() => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.property.name,
              style: montserrat.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.locationPin,
                  color: pinColor,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text('${widget.property.streetAddress}, ${widget.property.city}',
                    style: montserrat.copyWith(
                        fontSize: 14, color: secondaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '₹ ${widget.property.rent}',
                  style: montserrat.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                Text(
                  ' /Month',
                  style: montserrat.copyWith(
                      fontSize: 13, fontWeight: FontWeight.w600, color: secondaryColor),
                )
              ],
            ),
          ],
        ),
      );

  _buildChildren() => <Widget>[
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: myOrangeSecondary, width: 2),
          ),
          color: myOrangeSecondary,
          shadowColor: myOrange,
          elevation: 1.3,
          child: ListTile(
            title: Text(
              "Address",
              style: montserrat.copyWith(fontWeight: FontWeight.bold,color: myOrange),
            ),
            subtitle: Text(
                '${widget.property.name}, ${widget.property.streetAddress}, ${widget.property.city}, ${widget.property.streetAddress} - ${widget.property.pinCode}',
                style: unSelectedOptionTextStyle),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: myOrangeSecondary, width: 2),
          ),
          color: myOrangeSecondary,
          shadowColor: myOrange,
          elevation: 1.3,
          child: ListTile(
            // tileColor: myOrangeSecondary,
            title: Text('Information', style: montserrat.copyWith(fontWeight: FontWeight.bold,color: myOrange)),
            subtitle: Column(
              children: [
                DisplayData(title: 'Rent', subtitle: "₹ ${widget.property.rent}"),
                DisplayData(title: 'Deposit', subtitle: "₹ ${widget.property.deposit}"),
                DisplayData(title: 'BHK', subtitle: widget.property.bhk),
                DisplayData(title: 'Bathroom(s)', subtitle: widget.property.bathroom),
                DisplayData(title: 'Furniture', subtitle: widget.property.furniture),
              ],
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: myOrangeSecondary, width: 2),
          ),
          color: myOrangeSecondary,
          shadowColor: myOrange,
          elevation: 1.3,
          child: ListTile(
            tileColor: myOrangeSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text('Amenities', style: montserrat.copyWith(fontWeight: FontWeight.bold,color: myOrange)),
            subtitle: Wrap(
              children: [
                for (String amenity in widget.property.amenities.where(
                  (element) => element.isNotEmpty,
                ))
                  Text('$amenity,\t', style: unSelectedOptionTextStyle)
              ],
            ),
          ),
        ),
        Focus(
          autofocus: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: SaveAndNextBtn(
              onPressed: () => Fluttertoast.showToast(msg: 'hi'),
              msg: 'Contact',
            ),
          ),
        ),
      ];

  _buildTopWidget(String widgetName) {
    switch (widgetName) {
      case 'bookmark':
        return InkWell(
          onTap: () async {
            bool add = !DataProvider.instance.getUser.bookmarks.contains(widget.property.id);
            setState(() => DataProvider.instance.manageBookmark(widget.property.id, add));
            await ApiHandler.instance.saveBookMark(widget.property.id, add);
          },
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black,
            ),
            child: Icon(
              (!DataProvider.instance.getUser.bookmarks.contains(widget.property.id))
                  ? Icons.bookmark_add_sharp
                  : Icons.bookmark_remove_sharp,
              color: Colors.white,
            ),
          ),
        );
      case 'delete':
        return FloatingActionButton.small(
          onPressed: () => _handelDelete(widget.property),
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        );
      default:
        return const SizedBox();
    }
  }

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
                      (error, stackTrace) => setState(() => Navigator.pop(context)),
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
}

class DisplayData extends StatelessWidget {
  const DisplayData({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: unSelectedOptionTextStyle,
        ),
        Text(subtitle, style: unSelectedOptionTextStyle)
      ],
    );
  }
}
