import 'dart:io';

import 'package:chatty/common/enums/message_enum.dart';
import 'package:chatty/common/repository/common_firebase_storage_repository.dart';
import 'package:chatty/common/utils/utils.dart';
import 'package:chatty/models/chat_contact.dart';
import 'package:chatty/models/message.dart';
import 'package:chatty/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  FirebaseFirestore firestore;
  FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  _saveDataToContactSubCollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String messageText,
    DateTime timeSent,
  ) async {
    // To save chat contact in receivers chat list screen
    final receiverChatContact = ChatContact(
      senderUserData.name,
      senderUserData.profilePic,
      senderUserData.uid,
      timeSent,
      messageText,
    );
    await firestore
        .collection('users')
        .doc(receiverUserData.uid)
        .collection('chats')
        .doc(senderUserData.uid)
        .set(
          receiverChatContact.toMap(),
        );

    // To save chat contact in sender (current user) chat list screen
    final senderChatContact = ChatContact(
      receiverUserData.name,
      receiverUserData.profilePic,
      receiverUserData.uid,
      timeSent,
      messageText,
    );
    await firestore
        .collection('users')
        .doc(senderUserData.uid)
        .collection('chats')
        .doc(receiverUserData.uid)
        .set(
          senderChatContact.toMap(),
        );
  }

  _saveMessageToMessageSubcollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String messageText,
    String messageId,
    MessageTypeEnum type,
    DateTime timeSent,
  ) async {
    // Save message in sender (current user) collection
    final senderMessage = Message(
      senderId: senderUserData.uid,
      receiverId: receiverUserData.uid,
      messageId: messageId,
      message: messageText,
      type: type,
      timeSent: timeSent,
      isSeen: false,
    );
    await firestore
        .collection('users')
        .doc(senderUserData.uid)
        .collection('chats')
        .doc(receiverUserData.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          senderMessage.toMap(),
        );

    // Save message in receivers message collection
    final receiverMessage = Message(
      senderId: senderUserData.uid,
      receiverId: receiverUserData.uid,
      messageId: messageId,
      message: messageText,
      type: type,
      timeSent: timeSent,
      isSeen: false,
    );
    await firestore
        .collection('users')
        .doc(receiverUserData.uid)
        .collection('chats')
        .doc(senderUserData.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          receiverMessage.toMap(),
        );
  }

  sendTextMessage({
    required BuildContext context,
    required String messageText,
    required String receiverUserId,
    required UserModel senderUserData,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;

      var receiverUserDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      // Since we have receiver user id, receiverUserDataMap.data() wont be null
      receiverUserData = UserModel.fromMap(receiverUserDataMap.data()!);

      // Create/Edit data for Sender and Receiver chat list screen
      _saveDataToContactSubCollection(
        senderUserData,
        receiverUserData,
        messageText,
        timeSent,
      );

      // Save data in Sender and Receivers Messages collection
      final messageId = const Uuid().v1();
      _saveMessageToMessageSubcollection(
        senderUserData,
        receiverUserData,
        messageText,
        messageId,
        MessageTypeEnum.text,
        timeSent,
      );
    } catch (err) {
      if (context.mounted) {
        showSnackBar(context: context, content: err.toString());
      }
    }
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        final contact = ChatContact.fromMap(document.data());
        var receiverUserData =
            await firestore.collection('users').doc(contact.contactId).get();
        var receiver = UserModel.fromMap(receiverUserData.data()!);

        contacts.add(
          ChatContact(
            receiver.name,
            receiver.profilePic,
            contact.contactId,
            contact.timeSent,
            contact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String receiverId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var doc in event.docs) {
        final message = Message.fromMap(doc.data());
        messages.add(message);
      }
      return messages;
    });
  }

  sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required MessageTypeEnum messageEnum,
    required ProviderRef ref,
  }) async {
    try {
      var timeSent = DateTime.now();
      final messageId = const Uuid().v1();
      UserModel receiverUserData;

      var receiverUserDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      // Since we have receiver user id, receiverUserDataMap.data() wont be null
      receiverUserData = UserModel.fromMap(receiverUserDataMap.data()!);

      String fileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId',
            file,
          );

      // Create/Edit data for Sender and Receiver chat list screen
      var contactMessage = "";
      switch (messageEnum) {
        case MessageTypeEnum.image:
          contactMessage = "📷 Photo";
          break;
        case MessageTypeEnum.video:
          contactMessage = "📹 Video";
          break;
        case MessageTypeEnum.audio:
          contactMessage = "🎵 Audio";
          break;
        case MessageTypeEnum.gif:
          contactMessage = "GIF";
          break;
        default:
          contactMessage = "GIF";
      }
      _saveDataToContactSubCollection(
        senderUserData,
        receiverUserData,
        contactMessage,
        timeSent,
      );

      // Save data in Sender and Receivers Messages collection

      _saveMessageToMessageSubcollection(
        senderUserData,
        receiverUserData,
        fileUrl,
        messageId,
        messageEnum,
        timeSent,
      );
    } catch (err) {
      if (context.mounted) {
        showSnackBar(context: context, content: err.toString());
      }
    }
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (err) {
      if (context.mounted) {
        showSnackBar(context: context, content: err.toString());
      }
    }
  }
}
