import 'package:chatty/common/widgets/error_page.dart';
import 'package:chatty/common/widgets/loader.dart';
import 'package:chatty/features/select_contact/controller/select_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({super.key});

  void _selectContact(
    BuildContext context,
    WidgetRef ref,
    Contact selectedContact,
  ) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(context, selectedContact);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select contact"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: ref.watch(getContactsProvider).when(
        data: (contactList) {
          return ListView.builder(
            itemCount: contactList.length,
            itemBuilder: ((context, index) {
              final contact = contactList[index];
              return InkWell(
                onTap: () => _selectContact(context, ref, contact),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(
                      contact.displayName,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    leading: contact.photo == null
                        ? null
                        : CircleAvatar(
                            backgroundImage: MemoryImage(contact.photo!),
                            radius: 30.r,
                          ),
                  ),
                ),
              );
            }),
          );
        },
        error: (error, trace) {
          return ErrorScreen(title: error.toString());
        },
        loading: () {
          return const Loader();
        },
      ),
    );
  }
}
