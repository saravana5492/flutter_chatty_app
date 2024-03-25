import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatty/common/repository/common_firebase_storage_repository.dart';
import 'package:chatty/common/utils/utils.dart';
import 'package:chatty/models/user_model.dart';
import 'package:chatty/routes.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    fireStore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  AuthRepository({
    required this.auth,
    required this.fireStore,
  });

  Future<UserModel?> getUserData() async {
    var userData =
        await fireStore.collection("users").doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhoneNumber(
    BuildContext context,
    String phoneNumber,
  ) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credencial) async {
          await auth.signInWithCredential(credencial);
        },
        verificationFailed: (err) {
          if (context.mounted) {
            showSnackBar(
                context: context,
                content: err.message ?? "Something went wrong!");
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          if (context.mounted) {
            Navigator.of(context)
                .pushNamed(AppRoutes.otpRouteName, arguments: verificationId);
          }
        },
        codeAutoRetrievalTimeout: (timeOut) {},
      );
    } catch (err) {
      if (context.mounted) {
        showSnackBar(context: context, content: err.toString());
      }
    }
  }

  void verifyOTP(
    BuildContext context,
    String verificationId,
    String smsCode,
  ) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(phoneAuthCredential);
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.userInformationRouteName, (route) => false);
      }
    } catch (err) {
      if (context.mounted) {
        showSnackBar(context: context, content: err.toString());
      }
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          "https://www.cgteam.com/wp-content/uploads/2018/11/Profile_avatar_placeholder_large.png";
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              "profilePic/$uid",
              profilePic,
            );
      }

      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        phoneNumber: auth.currentUser!.phoneNumber!,
        isOnline: true,
        groupId: [],
      );

      await fireStore.collection("users").doc(uid).set(user.toMap());

      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.mobileLayoutRouteName, (route) => false);
      }
    } catch (err) {
      if (context.mounted) {
        showSnackBar(context: context, content: err.toString());
      }
    }
  }

  Stream<UserModel> userData(String userId) {
    return fireStore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await fireStore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}
