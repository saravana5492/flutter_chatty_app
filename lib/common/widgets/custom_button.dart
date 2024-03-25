import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatty/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.buttonWidth,
  });

  final String title;
  final VoidCallback onPressed;
  final double? buttonWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (buttonWidth != null)
          ? buttonWidth!
          : ScreenUtil().screenWidth - 40.w,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
          backgroundColor: tabColor,
          foregroundColor: blackColor,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
