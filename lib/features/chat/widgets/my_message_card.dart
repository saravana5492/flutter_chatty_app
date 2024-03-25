import 'package:chatty/common/enums/message_enum.dart';
import 'package:chatty/features/chat/widgets/display_text_gif_image_message.dart';
import 'package:flutter/material.dart';
import 'package:chatty/colors.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageTypeEnum messageEnum;
  final bool isSeen;

  const MyMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.messageEnum,
    required this.isSeen,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
          minWidth: 150,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: messageColor,
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
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      !isSeen ? Icons.done : Icons.done_all,
                      size: 20,
                      color: !isSeen ? Colors.white60 : Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
