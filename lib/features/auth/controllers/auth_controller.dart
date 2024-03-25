// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatty/common/utils/utils.dart';
import 'package:chatty/features/auth/repository/auth_repository.dart';
import 'package:chatty/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  const AuthController({
    required this.authRepository,
    required this.ref,
  });

  final AuthRepository authRepository;
  final ProviderRef ref;

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getUserData();
    return user;
  }

  String? validateSignInData(String? phoneNumber, Country? country) {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      return "Phone number is required";
    }
    if (!isValidMobile(phoneNumber)) {
      return "Please enter valid phone number";
    }
    if (country == null) {
      return "Please pick the country";
    }
    return null;
  }

  void signInWithPhoneNumber({
    required BuildContext context,
    required String phoneNumber,
  }) {
    authRepository.signInWithPhoneNumber(context, phoneNumber);
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String smsCode,
  }) {
    authRepository.verifyOTP(context, verificationId, smsCode);
  }

  void saveUserToFirebase(
    BuildContext context,
    String name,
    File? profilePic,
  ) {
    authRepository.saveUserDataToFirebase(
        name: name, profilePic: profilePic, ref: ref, context: context);
  }

  Stream<UserModel> userData(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
