import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty/common/enums/message_enum.dart';
import 'package:chatty/features/chat/widgets/audio_message_item.dart';
import 'package:chatty/features/chat/widgets/video_message_item.dart';
import 'package:flutter/material.dart';

class DisplayTextGifImageMessage extends StatelessWidget {
  const DisplayTextGifImageMessage({
    super.key,
    required this.message,
    required this.date,
    required this.messageEnum,
  });

  final String message;
  final String date;
  final MessageTypeEnum messageEnum;

  @override
  Widget build(BuildContext context) {
    switch (messageEnum) {
      case MessageTypeEnum.text:
        return Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        );
      case MessageTypeEnum.video:
        return VideoMessageItem(videoUrl: message);
      case MessageTypeEnum.image:
        return CachedNetworkImage(imageUrl: message);
      case MessageTypeEnum.audio:
        return AudioMessageItem(message: message);
      default:
        return Container();
    }
  }
}
