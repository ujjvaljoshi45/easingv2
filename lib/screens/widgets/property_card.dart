import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/screens/add_property/step_0_add_property_page.dart';
import 'package:easypg/services/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/screens/add_property/widgets/save_and_next_btn.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final _expansionController = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0.r),
        ),
        elevation: 4,
        child: Column(
          children: [
            _buildTitleWidget(),
            ExpansionTile(
              controller: _expansionController,

              showTrailingIcon: false,
              shape: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: Colors.transparent)),
              title: _buildSubTitleWidget(),
              // subtitle:,
              children: _buildChildren(),
            ),
          ],
        ),
      ),
    );
  }

  _buildTitleWidget() => InkWell(
        onTap: () => setState(() => _expansionController.isExpanded
            ? _expansionController.expand()
            : _expansionController.collapse()),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0.r),
                topRight: Radius.circular(12.0.r),
              ),
              child: CarouselSlider.builder(
                itemCount: widget.property.photos.length,
                itemBuilder: (context, index, realIndex) => CachedNetworkImage(
                  imageUrl: widget.property.photos[index],
                  width: double.infinity.w,
                  fit: BoxFit.cover,
                ),
                options: CarouselOptions(
                    autoPlay: true,
                    autoPlayCurve: Easing.linear,
                    pauseAutoPlayInFiniteScroll: true,
                    autoPlayAnimationDuration: _pageChangeDuration,
                    onPageChanged: (index, reason) => setState(
                            () => _currentPhotoIndex = index,
                          ),
                    enableInfiniteScroll: true,
                    viewportFraction: 1,
                    aspectRatio: 16 / 9,
                    height: 250.h),
              ),
            ),
            Positioned(
              top: 10.h,
              left: 10.w,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: myOrangeSecondary,
                  borderRadius: BorderRadius.circular(8.0.r),
                ),
                child: Text(
                  widget.property.propertyType,
                  style: montserrat.copyWith(
                    color: myOrange,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10.h,
              right: 10.w,
              child: widget.topWidget != null
                  ? _buildTopWidget(widget.topWidget!)
                  : const SizedBox.shrink(),
            ),
            Positioned(
              bottom: 10.h,
              right: 10.w,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.black.withOpacity(0.2)),
                child: Row(
                  children: [
                    for (int i = 0; i < widget.property.photos.length; i++)
                      AnimatedContainer(
                        duration: _pageChangeDuration,
                        curve: Curves.decelerate,
                        margin: const EdgeInsets.all(2.0),
                        width: 10.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _currentPhotoIndex ? myOrange : myOrangeSecondary),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  _buildSubTitleWidget() => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Name
            Text(
              widget.property.name,
              style: montserrat.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Darker shade for the title
              ),
            ),
            SizedBox(height: 4.h), // Spacing between elements

            // Location with Icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.locationPin,
                  color: pinColor,
                  size: 16.sp, // Slightly larger icon for better visibility
                ),
                SizedBox(width: 6.w), // Adjust spacing for better balance
                Expanded(
                  child: Text(
                    '${widget.property.streetAddress}, ${widget.property.city}',
                    style: montserrat.copyWith(
                      fontSize: 14.sp,
                      color: secondaryColor,
                      fontWeight: FontWeight.w600, // Increase weight slightly for clarity
                    ),
                    overflow: TextOverflow.ellipsis, // Handle overflow text gracefully
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h), // Adjust spacing for cleaner separation

            // Rent Information
            Row(
              children: [
                Text(
                  '₹ ${widget.property.rent}',
                  style: montserrat.copyWith(
                    fontSize: 18.sp, // Increase size slightly for emphasis
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 4.w), // Space between Rent and "/Month"
                Text(
                  '/Month',
                  style: montserrat.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: secondaryColor, // Slightly lighter color for less emphasis
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  _buildChildren() => <Widget>[
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0.r),
            side: BorderSide(color: myOrange, width: 1.5.w),
          ),
          color: myOrangeSecondary,
          shadowColor: Colors.grey.withOpacity(0.5),
          elevation: 3.0,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            title: Text(
              "Address",
              style: montserrat.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: myOrange,
              ),
            ),
            subtitle: Text(
              '${widget.property.name}, ${widget.property.streetAddress}, ${widget.property.city}, ${widget.property.streetAddress} - ${widget.property.pinCode}',
              style: unSelectedOptionTextStyle.copyWith(fontSize: 14.sp),
            ),
          ),
        ),

        // Information Card
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0.r),
            side: BorderSide(color: myOrange, width: 1.5.w),
          ),
          color: myOrangeSecondary,
          shadowColor: Colors.grey.withOpacity(0.5),
          elevation: 3.0,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            title: Text(
              'Information',
              style: montserrat.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: myOrange,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                DisplayData(title: 'Rent', subtitle: "₹ ${widget.property.rent}"),
                SizedBox(height: 4.h),
                DisplayData(title: 'Deposit', subtitle: "₹ ${widget.property.deposit}"),
                SizedBox(height: 4.h),
                DisplayData(title: 'BHK', subtitle: widget.property.bhk),
                SizedBox(height: 4.h),
                DisplayData(title: 'Bathroom(s)', subtitle: widget.property.bathroom),
                SizedBox(height: 4.h),
                DisplayData(title: 'Furniture', subtitle: widget.property.furniture),
              ],
            ),
          ),
        ),

        // Amenities Card
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0.r),
            side: BorderSide(color: myOrange, width: 1.5.w),
          ),
          color: myOrangeSecondary,
          shadowColor: Colors.grey.withOpacity(0.5),
          elevation: 3.0,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            title: Text(
              'Amenities',
              style: montserrat.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: myOrange,
              ),
            ),
            subtitle: Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              children: widget.property.amenities
                  .where((element) => element.isNotEmpty)
                  .map((amenity) => Chip(
                        label: Text(amenity,
                            style: unSelectedOptionTextStyle.copyWith(fontSize: 12.sp)),
                        backgroundColor: myOrangeSecondary.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),

        // Contact Button
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
          child: SaveAndNextBtn(
            onPressed: () => Fluttertoast.showToast(msg: 'hi'),
            msg: 'Contact',
            style: ElevatedButton.styleFrom(
              backgroundColor: myOrange,
              textStyle: montserrat.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
      ];

  _buildTopWidget(String widgetName) {
    switch (widgetName) {
      case 'bookmark':
        return BookmarkWidget(
          isBookmarked: DataProvider.instance.getUser.bookmarks.contains(widget.property.id),
          onBookmarkToggle: () async {
            bool add = !DataProvider.instance.getUser.bookmarks.contains(widget.property.id);
            setState(() => DataProvider.instance.manageBookmark(widget.property.id, add));
            await ApiHandler.instance.saveBookMark(widget.property.id, add);
          },
        );
      case 'delete':
        return _buildMenu();
      default:
        return const SizedBox();
    }
  }

  _buildMenu() => PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            onTap: _handleEdit,
            child: Text("Edit"),
          ),
          PopupMenuItem(
            onTap: _handelDelete,
            child: Text("Delete"),
          )
        ],
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6.r),
              backgroundBlendMode: BlendMode.overlay),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: const FaIcon(
                FontAwesomeIcons.barsStaggered,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
  _handleEdit() {
    AddPropertyProvider.instance.property = widget.property;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPropertyPage(),
        ));
  }

  _handelDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Property.'),
          content: const Text("Are you sure you want to delete property\nThis Won't be undone!"),
          actions: [
            TextButton(
                onPressed: () async => await ApiHandler.instance
                    .deleteProperty(widget.property.id)
                    .whenComplete(
                      () => setState(() {
                        DataProvider.instance.getUser.myProperties.removeWhere(
                          (element) => element == widget.property.id,
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
                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18.sp),
                )),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "NO",
                  style: montserrat.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 18.sp),
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

class BookmarkWidget extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  const BookmarkWidget({super.key, required this.isBookmarked, required this.onBookmarkToggle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onBookmarkToggle,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            color: Colors.black,
            backgroundBlendMode: BlendMode.overlay),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FaIcon(
              isBookmarked ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
