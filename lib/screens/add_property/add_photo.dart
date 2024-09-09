import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:easypg/model/providers/property_provider.dart';
import 'package:easypg/screens/add_property/save_and_next_btn.dart';
import 'package:easypg/utils/tools.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({super.key, required this.handelPageChange});
  final Function handelPageChange;

  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {
  List<Uint8List?> images = List.generate(4, (index) => null,);
  bool isLoading = false;
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
            InkWell(
                onTap: () async => await _pickImage(0),
                child: ImageTile(
                  image: images[0],
                )),
            InkWell(
                onTap: () async => await _pickImage(1),
                child: ImageTile(
                  image: images[1],
                )),
          ],
        ),
        space(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
                onTap: () async => await _pickImage(2),
                child: ImageTile(
                  image: images[2],
                )),
            InkWell(
                onTap: () async => await _pickImage(3),
                child: ImageTile(
                  image: images[3],
                )),
          ],
        ),
        const Spacer(),
        isLoading
            ? const Center(
              child: CircularProgressIndicator(),
            )
            : SaveAndNextBtn(onPressed: _manageSave, msg: 'Save'),
        space(20)
      ],
    );
  }

  _manageSave() async {

    setState(() => isLoading = true);
    try {
      FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://easypg-316db.appspot.com');
      List<String> res = [];
      for (int i = 0; i < images.length; i++) {
        final ref = storage.ref('property/${getAppUser(context).uid}/$i.png');
        await ref.putData(images[i]!);
        res.add(await ref.getDownloadURL());
      }
      getPropertyProvider(context).photos = res;
      getPropertyProvider(context).uploaderId = getAppUser(context).uid;
      Provider.of<PropertyProvider>(context, listen: false).uploadToFirestore();
      Navigator.pop(context);
    } catch (e,stackTrace) {
      logError('save error', e, stackTrace);
      showToast('Error Occurred', Colors.redAccent);
    }
    setState(() => isLoading = false);
  }

  Future<void> _pickImage(int index) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? tempFile = (await imagePicker.pickImage(
      source: ImageSource.gallery,
    ));
    if (tempFile != null) {
      final temp = await tempFile.readAsBytes();
      images[index] = temp;
    }
    setState(() {

    });
  }
}

class ImageTile extends StatelessWidget {
  const ImageTile({super.key, required this.image});
  final Uint8List? image;
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      stackFit: StackFit.loose,
      child: Container(
          height: getWidth(context) * 0.4,
          width: getWidth(context) * 0.4,
          decoration: const BoxDecoration(),
          child: image == null
              ? const Center(
                  child: Icon(
                    Icons.add,
                    size: 32,
                  ),
                )
              : Image.memory(image!)),
    );
  }
}
