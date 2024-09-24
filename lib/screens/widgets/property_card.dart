import 'package:cached_network_image/cached_network_image.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key, required this.property, this.topWidget});
  final Property property;
  final Map<String, dynamic>? topWidget;
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
          shape: const OutlineInputBorder(borderSide: BorderSide(width: 0,color: Colors.transparent)),
          title: _buildTitleWidget(),
          subtitle: _buildSubTitleWidget(),
          children: _buildChildren(),
        ),
      ),
    );
  }
  _buildTitleWidget() =>  Stack(
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: CachedNetworkImage(
          imageUrl: property.photos.first,
          height: 225,
          width: double.infinity,
          fit: BoxFit.cover,
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
            property.propertyType,
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
        child: topWidget != null
            ? GestureDetector(
          child: topWidget!['widget'],
          onTap: topWidget!['callback'],
        )
            : const SizedBox.shrink(),
      )
    ],
  );
  _buildSubTitleWidget() => Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          property.name,
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
            Text('${property.streetAddress}, ${property.city}',
                style: montserrat.copyWith(
                    fontSize: 14, color: secondaryColor, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              '₹ ${property.rent}',
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
  _buildChildren() => [];
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
