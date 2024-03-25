import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatty/colors.dart';
import 'package:chatty/features/auth/controllers/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  const OTPScreen({
    super.key,
    required this.verificationId,
  });

  final String verificationId;

  void _sendSMSCode({
    required WidgetRef ref,
    required BuildContext context,
    required String smsCode,
  }) {
    ref.read(authControllerProvider).verifyOTP(
        context: context, verificationId: verificationId, smsCode: smsCode);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Verifying your number",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("We have sent an SMS with code"),
                SizedBox(height: 10.h),
                SizedBox(
                  width: ScreenUtil().screenWidth * 0.5,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 15.sp),
                    decoration: const InputDecoration(
                      hintText: "- - - - - -",
                      hintStyle: TextStyle(fontSize: 32),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: tabColor,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 6) {
                        _sendSMSCode(
                          ref: ref,
                          context: context,
                          smsCode: value.trim(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
