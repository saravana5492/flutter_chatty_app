import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatty/colors.dart';
import 'package:chatty/common/app_texts.dart';
import 'package:chatty/common/widgets/custom_button.dart';
import 'package:chatty/routes.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.loginRouteName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Text(
                landingWelcomeText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.sp,
                  color: whiteColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Center(
                child: Image.asset(
                  "assets/bg.png",
                  color: tabColor,
                  fit: BoxFit.cover,
                  width: ScreenUtil().screenWidth * 0.80,
                  height: ScreenUtil().screenWidth * 0.80,
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    landingTermsText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: greyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    title: landingAgreeButtonTitle,
                    onPressed: () => _navigateToLoginScreen(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
