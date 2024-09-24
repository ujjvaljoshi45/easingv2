import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/screens/add_property/save_and_next_btn.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PropertyCard extends StatefulWidget {
  const PropertyCard({super.key, required this.property, this.topWidget});
  final Property property;
  final Map<String, dynamic>? topWidget;

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  final CarouselSliderController _carouselSliderController = CarouselSliderController();
  final Duration _pageChangeDuration = const Duration(milliseconds: 150);
  int _currentPhotoIndex = 0;
  final FocusNode _focusNode = FocusNode();

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
          showTrailingIcon: false,
          initiallyExpanded: true,
          onExpansionChanged: (value) => value ? _focusNode.requestFocus() : null,
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
            child:
              CarouselSlider.builder(itemCount: widget.property.photos.length, itemBuilder: (context, index, realIndex) =>
                        CachedNetworkImage(
                          imageUrl: widget.property.photos[index],
                          height: 225,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                  , options:
                    CarouselOptions(
                      autoPlay: false,
                      autoPlayAnimationDuration: _pageChangeDuration,
                      onPageChanged: (index, reason) => setState(() => _currentPhotoIndex = index,),
                      enableInfiniteScroll: false,
                      viewportFraction: 0.8,
                      aspectRatio: 16/9,
                      enlargeFactor: 0.3,
                      enlargeStrategy: CenterPageEnlargeStrategy.scale
                    ),
              )
            // CarouselSlider(
            //   carouselController: _carouselSliderController ,
            //     items: List.generate(
            //       widget.property.photos.length,
            //       (index) =>
            //       CachedNetworkImage(
            //         imageUrl: widget.property.photos[index],
            //         height: 225,
            //         width: double.infinity,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //     options:
            //     CarouselOptions(
            //       autoPlay: false,
            //       autoPlayAnimationDuration: _pageChangeDuration,
            //       onPageChanged: (index, reason) => setState(() => _currentPhotoIndex = index,),
            //       enableInfiniteScroll: false,
            //       viewportFraction: 0.8,
            //       aspectRatio: 16/9,
            //       enlargeFactor: 0.3,
            //       enlargeStrategy: CenterPageEnlargeStrategy.scale
            //     ),),
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: widget.topWidget != null
                ? GestureDetector(
                    child: widget.topWidget!['widget'],
                    onTap: widget.topWidget!['callback'],
                  )
                : const SizedBox.shrink(),
          ),
          Positioned(
            bottom: 10,
              right: 10,
              child: Row(
                children: [
                  for (int i = 0; i < widget.property.photos.length; i++)
                    AnimatedContainer(
                      duration: _pageChangeDuration,
                      curve: Curves.decelerate,
                      margin: const EdgeInsets.all(2.0),
                      width: 10,height: 10,decoration: BoxDecoration(shape: BoxShape.circle, color : i == _currentPhotoIndex ? myOrange : myOrangeSecondary),
                    )
                ],
              )
          )
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
                Icon(
                  Icons.location_pin,
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
        ListTile(
          title: const Text("Address"),
          subtitle: Text(
              '${widget.property.name}, ${widget.property.streetAddress}, ${widget.property.city}, ${widget.property.streetAddress} - ${widget.property.pinCode}'),
        ),
        ListTile(
          title: const Text('Information'),
          subtitle: Column(
            children: [
              DisplayData(title: 'Rent', subtitle: widget.property.rent),
              DisplayData(title: 'Deposit', subtitle: widget.property.deposit),
              DisplayData(title: 'BHK', subtitle: widget.property.bhk),
              DisplayData(title: 'Bathroom(s)', subtitle: widget.property.bathroom),
              DisplayData(title: 'Furniture', subtitle: widget.property.furniture),
            ],
          ),
        ),
        ListTile(
          title: const Text('Amenities'),
          subtitle: Wrap(
            children: [
              for (String amenity in widget.property.amenities.where(
                (element) => element.isNotEmpty,
              ))
                Text('$amenity,\t')
            ],
          ),
        ),
        Focus(
          autofocus: true,
          focusNode: _focusNode,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: SaveAndNextBtn(
              onPressed: () => Fluttertoast.showToast(msg: 'hi'),
              msg: 'Contact',
            ),
          ),
        ),
      ];
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
