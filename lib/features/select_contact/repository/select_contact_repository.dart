// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatty/common/utils/utils.dart';
import 'package:chatty/models/user_model.dart';
import 'package:chatty/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    fireStore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore fireStore;

  SelectContactRepository({
    required this.fireStore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (err) {
      debugPrint(err.toString());
    }
    return contacts;
  }

  void selectContact(BuildContext context, Contact selectedContact) async {
    try {
      var allUsers = await fireStore.collection("users").get();
      bool isFound = false;

      for (var document in allUsers.docs) {
        final userData = UserModel.fromMap(document.data());
        final selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(" ", "");
        if (userData.phoneNumber == selectedPhoneNumber) {
          isFound = true;
          if (context.mounted) {
            Navigator.of(context)
                .pushNamed(AppRoutes.mobileChatScreenRouteName, arguments: {
              'name': userData.name,
              'uid': userData.uid,
            });
          }
          break;
        }
      }
      if (context.mounted) {
        if (!isFound) {
          showSnackBar(
            context: context,
            content: "User not registered with this app.",
          );
        }
      }
    } catch (err) {
      if (context.mounted) {
        showSnackBar(context: context, content: err.toString());
      }
    }
  }
}
