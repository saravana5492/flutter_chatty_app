import 'package:chatty/common/widgets/loader.dart';
import 'package:chatty/features/chat/controller/chat_controller.dart';
import 'package:chatty/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatty/features/chat/widgets/my_message_card.dart';
import 'package:chatty/features/chat/widgets/sender_message_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({super.key, required this.receiverId});

  final String receiverId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController _messageScrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _messageScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ref.read(chatControllerProvider).getChatStream(widget.receiverId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        return ListView.builder(
          reverse: true,
          controller: _messageScrollController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final allMessages = snapshot.data!;
            if (allMessages.isEmpty) {
              return null;
            }
            // We are taking messages like this to scroll to bottom on new Messages.
            final message = allMessages[allMessages.length - 1 - index];
            final timeSent = DateFormat('hh:mm a').format(message.timeSent);

            if (!(message.isSeen) &&
                message.receiverId == FirebaseAuth.instance.currentUser!.uid) {
              ref.read(chatControllerProvider).setChatMessageSeen(
                    context,
                    widget.receiverId,
                    message.messageId,
                  );
            }
            if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: message.message,
                date: timeSent,
                messageEnum: message.type,
                isSeen: message.isSeen,
              );
            }
            return SenderMessageCard(
              message: message.message,
              date: timeSent,
              messageEnum: message.type,
            );
          },
        );
      },
    );
  }
}
