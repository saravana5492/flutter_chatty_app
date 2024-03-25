import 'package:chatty/features/select_contact/repository/select_contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return SelectContactController(
    selectContactRepository,
    ref,
  );
});

class SelectContactController {
  final SelectContactRepository selectContactRepository;
  final ProviderRef ref;

  SelectContactController(this.selectContactRepository, this.ref);

  void selectContact(BuildContext context, Contact selectedContact) {
    selectContactRepository.selectContact(context, selectedContact);
  }
}
