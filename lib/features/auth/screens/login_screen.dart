import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatty/colors.dart';
import 'package:chatty/common/utils/utils.dart';
import 'package:chatty/common/widgets/custom_button.dart';
import 'package:chatty/features/auth/controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneNumberController = TextEditingController();
  Country? _country;

  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
  }

  void _pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          _country = country;
        });
      },
    );
  }

  void _validatePhoneNumber() {
    final phoneNumber = _phoneNumberController.text;
    final error = ref
        .read(authControllerProvider)
        .validateSignInData(phoneNumber, _country);
    if (error != null) {
      showSnackBar(context: context, content: error);
      return;
    }
    _sendPhoneNumber(context, "+${_country!.phoneCode}$phoneNumber");
  }

  void _sendPhoneNumber(BuildContext context, String phoneNumber) {
    ref.read(authControllerProvider).signInWithPhoneNumber(
          context: context,
          phoneNumber: phoneNumber,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Phone number Verification",
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Chatty will verify your phone number"),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: _pickCountry,
                child: const Text("Pick Country"),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    (_country != null) ? "+${_country!.phoneCode}" : "",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontSize: 15.sp),
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                        hintText: "phone number",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: tabColor,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  )
                ],
              ),
              const Spacer(),
              CustomButton(
                title: "NEXT",
                buttonWidth: 120.w,
                onPressed: _validatePhoneNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
