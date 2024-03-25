import 'dart:io';

import 'package:chatty/common/enums/message_enum.dart';
import 'package:chatty/features/auth/controllers/auth_controller.dart';
import 'package:chatty/models/chat_contact.dart';
import 'package:chatty/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatty/features/chat/repositories/chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository, ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController(this.chatRepository, this.ref);

  void sendMessage(
    BuildContext context,
    String messageText,
    String receiverUserId,
  ) {
    ref.read(userDataProvider).whenData((value) {
      if (value != null) {
        chatRepository.sendTextMessage(
          context: context,
          messageText: messageText,
          receiverUserId: receiverUserId,
          senderUserData: value,
        );
      }
    });
  }

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> getChatStream(String receiverId) {
    return chatRepository.getChatStream(receiverId);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserId,
    MessageTypeEnum messageEnum,
  ) {
    ref.read(userDataProvider).whenData((value) {
      if (value != null) {
        chatRepository.sendFileMessage(
          context: context,
          file: file,
          receiverUserId: receiverUserId,
          senderUserData: value,
          messageEnum: messageEnum,
          ref: ref,
        );
      }
    });
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      receiverUserId,
      messageId,
    );
  }
}
