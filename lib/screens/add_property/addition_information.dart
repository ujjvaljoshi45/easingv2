import 'package:easypg/screens/add_property/save_and_next_btn.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';

class AdditionInformationPage extends StatefulWidget {
  final Function handelPageChange;
  const AdditionInformationPage({super.key, required this.handelPageChange});

  @override
  State<AdditionInformationPage> createState() => _AdditionInformationPageState();
}

class _AdditionInformationPageState extends State<AdditionInformationPage> {
  List<String> myItem = ['Breakfast','Lunch', 'Dinner', 'Drinking Water' ,'AC','Laundry','Cleaning'];
  List<bool> status = List.generate(10, (index) => false,);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 18.0),
      child: Column(
        children: [
          space(10),
          for (int i = 0; i < myItem.length; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(myItem[i],style: montserrat.copyWith(fontWeight: FontWeight.bold, fontSize: 18),),Checkbox(value: status[i], onChanged: (value) => setState(()=>status[i]=value ?? status[i]),),
              ],
            ),
          space(20),
          const TextField(decoration: InputDecoration(hintText: 'Other...'),),
          Spacer(),
          SaveAndNextBtn(onPressed: _manageSave, msg: 'Save And Next'),
          space(20),
        ],
      ),
    );
  }
  _manageSave() {
    widget.handelPageChange();
  }
}
