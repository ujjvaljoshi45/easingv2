import 'package:easypg/provider/add_property_provider.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddAmenitiesPage extends StatefulWidget {
  final Function handelPageChange;
  const AddAmenitiesPage({super.key, required this.handelPageChange});

  @override
  State<AddAmenitiesPage> createState() => _AddAmenitiesPageState();
}

class _AddAmenitiesPageState extends State<AddAmenitiesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        space(10),
        for (int i = 0;
            i < AddPropertyProvider.instance.myAmenities.length;
            i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AddPropertyProvider.instance.myAmenities.keys.toList()[i],
                style: montserrat.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              Checkbox(
                value: AddPropertyProvider.instance.myAmenities[
                    AddPropertyProvider.instance.myAmenities.keys.toList()[i]],
                onChanged: (value) => setState(() =>
                    AddPropertyProvider.instance.myAmenities[
                        AddPropertyProvider.instance.myAmenities.keys
                            .toList()[i]] = value ??
                        AddPropertyProvider.instance.myAmenities[
                            AddPropertyProvider.instance.myAmenities.keys
                                .toList()[i]]!),
              ),
            ],
          ),
        space(20),
        const TextField(
          decoration: InputDecoration(hintText: 'Other...'),
        ),
      ],
    );
  }
}
