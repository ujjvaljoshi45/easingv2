import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({super.key});

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
              url: AddPropertyProvider.instance.property.photos.elementAtOrNull(0),index: 0,
            ),
            ImageTile(url: AddPropertyProvider.instance.property.photos.elementAtOrNull(1),index: 1,),
          ],
        ),
        space(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ImageTile(url: AddPropertyProvider.instance.property.photos.elementAtOrNull(2),index: 2,),
            ImageTile(url: AddPropertyProvider.instance.property.photos.elementAtOrNull(3),index: 3,),
          ],
        ),
      ],
    );
  }
}

class ImageTile extends StatefulWidget {
  const ImageTile({super.key, this.url, required this.index});
  final String? url;
  final int index;
  @override
  State<ImageTile> createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  String? url;
  late int index;
  @override
  void initState() {
    url = widget.url;
    index = widget.index;
    super.initState();
  }

  _addImage() async {
    XFile? file = (await ImagePicker().pickImage(source: ImageSource.gallery));
    if (file != null) {
      setState(() => url = file.path);
      AddPropertyProvider.instance.setPhotos(url!,index);
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
            child: url!.isEmpty
                ? Center(
                    child: Icon(
                      Icons.add,
                      size: 32.sp,
                    ),
                  )
                : url!.startsWith('http') ? CachedNetworkImage(imageUrl: url!) : Image.file(File(url!))),
      ),
    );
  }
}
