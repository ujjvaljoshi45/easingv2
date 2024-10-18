import 'package:easypg/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle montserrat = GoogleFonts.montserrat();

ButtonStyle selectedOptionButtonStyle = ButtonStyle(
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.r),
    ),
  ),
  backgroundColor: WidgetStatePropertyAll(black),
);

TextStyle selectedOptionTextStyle = montserrat.copyWith(
  fontSize: 16.sp,
  fontWeight: FontWeight.bold,
  color: white,
);

ButtonStyle unSelectedOptionButtonStyle = ButtonStyle(
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r), side: BorderSide(color: black, width: 2.w)),
  ),
  backgroundColor: WidgetStatePropertyAll(white),
);

TextStyle unSelectedOptionTextStyle = montserrat.copyWith(
  fontSize: 16.sp,
  fontWeight: FontWeight.bold,
  color: black,
);
