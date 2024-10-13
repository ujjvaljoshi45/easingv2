import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({super.key, required this.handelPageChange});
  final Function handelPageChange;

  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        space(20),
        printHeading('A good photo equals 10x more views.'),
        space(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ImageTile(
              url: AddPropertyProvider.instance.property.photos
                  .elementAtOrNull(0),
            ),
            ImageTile(
                url: AddPropertyProvider.instance.property.photos
                    .elementAtOrNull(1)),
          ],
        ),
        space(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ImageTile(
                url: AddPropertyProvider.instance.property.photos
                    .elementAtOrNull(2)),
            ImageTile(
                url: AddPropertyProvider.instance.property.photos
                    .elementAtOrNull(3)),
          ],
        ),
      ],
    );
  }
}

class ImageTile extends StatefulWidget {
  const ImageTile({super.key, this.url});
  final String? url;
  @override
  State<ImageTile> createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  String? url;
  @override
  void initState() {
    url = widget.url;
    super.initState();
  }

  _addImage() async {
    XFile? file = (await ImagePicker().pickImage(source: ImageSource.gallery));
    if (file != null) {
      setState(() => url = file.path);
      AddPropertyProvider.instance.setPhotos([url!]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _addImage,
      child: DottedBorder(
        stackFit: StackFit.loose,
        child: SizedBox(
            height: getWidth(context) * 0.4.w,
            width: getWidth(context) * 0.4.w,
            child: url == null
                ? Center(
                    child: Icon(
                      Icons.add,
                      size: 32.sp,
                    ),
                  )
                : Image.file(File(url!))),
      ),
    );
  }
}
