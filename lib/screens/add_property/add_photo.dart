import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/screens/add_property/save_and_next_btn.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({super.key, required this.handelPageChange});
  final Function handelPageChange;

  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {
  bool isLoading=false;

  _validate() {
    return AddPropertyProvider.instance.property.photos.length >= 4;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(child: CircularProgressIndicator(color: myOrange,)) : Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        space(20),
        printHeading('A good photo equals 10x more views.'),
        space(20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ImageTile(),
            ImageTile(),
          ],
        ),
        space(20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ImageTile(),
            ImageTile(),
          ],
        ),
        const Spacer(),
        SaveAndNextBtn(onPressed: () async {
          _validate() ?  await _save(): logEvent('Photos Empty: ${AddPropertyProvider.instance.property.photos.length}');
        }, msg: 'Save'),
        space(20)
      ],
    );
  }
  _save() async {
    setState(()=>isLoading=true);
    mounted ? await AddPropertyProvider.instance.save().then((value) => Navigator.pop(context) ,) : null;
  }
}

class ImageTile extends StatefulWidget {
  const ImageTile({super.key});

  @override
  State<ImageTile> createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  String? url;

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
            height: getWidth(context) * 0.4,
            width: getWidth(context) * 0.4,
            child: url == null
                ? const Center(
                    child: Icon(
                      Icons.add,
                      size: 32,
                    ),
                  )
                : Image.file(File(url!))),
      ),
    );
  }
}
