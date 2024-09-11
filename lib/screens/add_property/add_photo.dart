import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/screens/add_property/save_and_next_btn.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({super.key, required this.handelPageChange});
  final Function handelPageChange;

  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {
  bool isLoading = false;

  @override
  void initState() {
    logEvent('init');
    logEvent("e:${AddPropertyProvider.instance.property.photos.elementAtOrNull(1)}");
    super.initState();
  }

  _validate() {
    return AddPropertyProvider.instance.property.photos.length >= 4;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            color: myOrange,
          ))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              space(20),
              printHeading('A good photo equals 10x more views.'),
              space(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ImageTile(
                    url: AddPropertyProvider.instance.property.photos.elementAtOrNull(0),
                  ),
                  ImageTile(url: AddPropertyProvider.instance.property.photos.elementAtOrNull(1)),
                ],
              ),
              space(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ImageTile(url: AddPropertyProvider.instance.property.photos.elementAtOrNull(2)),
                  ImageTile(url: AddPropertyProvider.instance.property.photos.elementAtOrNull(3)),
                ],
              ),
              const Spacer(),
              SaveAndNextBtn(
                  onPressed: () async {
                    _validate()
                        ? await _save()
                        : logEvent(
                            'Photos Empty: ${AddPropertyProvider.instance.property.photos.length}');
                  },
                  msg: 'Save'),
              space(20)
            ],
          );
  }

  _save() async {
    setState(() => isLoading = true);
    mounted
        ? await AddPropertyProvider.instance
            .save()
            .then(
              (value) => Navigator.pop(context),
            )
            .onError(
            (error, stackTrace) {
              logError('save Error', error, stackTrace);

              Navigator.pop(context);
              Fluttertoast.showToast(
                  msg: 'Unable To Save Property!',
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white);
            },
          )
        : null;
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
