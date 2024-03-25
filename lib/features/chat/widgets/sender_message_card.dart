import 'package:chatty/common/enums/message_enum.dart';
import 'package:chatty/features/chat/widgets/display_text_gif_image_message.dart';
import 'package:flutter/material.dart';
import 'package:chatty/colors.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
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
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
          minWidth: 150,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: senderMessageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: (messageEnum == MessageTypeEnum.text)
                    ? const EdgeInsets.only(
                        left: 10, right: 30, top: 5, bottom: 20)
                    : const EdgeInsets.only(
                        left: 5, right: 5, top: 5, bottom: 25),
                child: DisplayTextGifImageMessage(
                    message: message, date: date, messageEnum: messageEnum),
              ),
              Positioned(
                bottom: 2,
                right: 10,
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
