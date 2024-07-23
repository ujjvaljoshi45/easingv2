import 'package:dotted_border/dotted_border.dart';
import 'package:easypg/screens/add_property/save_and_next_btn.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            ImageTile(),
            ImageTile(),
          ],
        ),
        space(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ImageTile(),
            ImageTile(),

          ],
        ),
        Spacer(),
        SaveAndNextBtn(onPressed: () {}, msg: 'Save'),
        space(20)
      ],
    );
  }
}

class ImageTile extends StatelessWidget {
  const ImageTile({super.key});

  @override
  Widget build(BuildContext context) {
    return
      DottedBorder(
        stackFit: StackFit.loose,
        child: Container(
        height: getWidth(context) * 0.4,
        width: getWidth(context) * 0.4,
        decoration: BoxDecoration(

        ),
        child: const Center(child: Icon(Icons.add,size: 32,),),
            ),
      );
  }
}
