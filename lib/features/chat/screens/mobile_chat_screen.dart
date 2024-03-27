// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatty/common/widgets/loader.dart';
import 'package:chatty/features/auth/controllers/auth_controller.dart';
import 'package:chatty/features/chat/widgets/bottom_chat_field.dart';
import 'package:chatty/models/user_model.dart';
import 'package:flutter/material.dart';

import 'package:chatty/colors.dart';
import 'package:chatty/features/chat/widgets/chat_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileChatScreen extends ConsumerWidget {
  const MobileChatScreen({
    super.key,
    required this.name,
    required this.uid,
  });

  final String name;
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userData(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                  Text(
                    (snapshot.data?.isOnline ?? false) ? 'online' : 'offline',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              );
            }),
        centerTitle: false,
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.video_call),
        //   ),
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.call),
        //   ),
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.more_vert),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ChatList(
                receiverId: uid,
              ),
            ),
            BottomChatField(receiverUserId: uid),
          ],
        ),
      ),
    );
  }
}
