import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyScreen extends StatelessWidget {
  final String message;


  const EmptyScreen({
    super.key,
    this.message = "Nothing to see here!",

  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/empty.png",
              width: 150.w,
              height: 150.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  size: 100.sp,
                  color: Colors.grey,
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: montserrat.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
