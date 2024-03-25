import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatty/colors.dart';
import 'package:chatty/common/utils/utils.dart';
import 'package:chatty/features/auth/controllers/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final _nameEditingController = TextEditingController();
  File? selectedImage;

  void _pickProfilePicture() async {
    selectedImage = await pickImageFromGallery(context);
    setState(() {});
  }

  void _storeUserData() {
    String name = _nameEditingController.text.trim();
    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserToFirebase(
            context,
            name,
            selectedImage,
          );
    }
  }

  @override
  void dispose() {
    _nameEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.h),
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    selectedImage == null
                        ? const CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://www.cgteam.com/wp-content/uploads/2018/11/Profile_avatar_placeholder_large.png"),
                            radius: 64,
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(selectedImage!),
                            radius: 64,
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: _pickProfilePicture,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autocorrect: false,
                        controller: _nameEditingController,
                        decoration: const InputDecoration(
                          hintText: "Enter your name",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: tabColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    IconButton(
                      onPressed: _storeUserData,
                      icon: const Icon(Icons.done),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
