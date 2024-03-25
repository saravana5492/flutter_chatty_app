import 'dart:io';
import 'package:chatty/colors.dart';
import 'package:chatty/common/enums/message_enum.dart';
import 'package:chatty/common/utils/utils.dart';
import 'package:chatty/features/chat/controller/chat_controller.dart';
import 'package:chatty/features/chat/widgets/bottom_chat_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({super.key, required this.receiverUserId});

  final String receiverUserId;

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final _messageTextController = TextEditingController();
  final _recorder = AudioRecorder();
  bool isMessageEntered = false;
  bool isRecording = false;

  void _sendTextMessage() async {
    if (isMessageEntered) {
      ref.read(chatControllerProvider).sendMessage(
            context,
            _messageTextController.text.trim(),
            widget.receiverUserId,
          );
      setState(() {
        _messageTextController.text = "";
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/recorded_message.aac';

      if (isRecording) {
        final recorderedPath = await _recorder.stop();
        if (recorderedPath != null) {
          sendFile(File(recorderedPath), MessageTypeEnum.audio);
        }
      } else {
        if (await _recorder.hasPermission()) {
          await _recorder.start(const RecordConfig(), path: path);
        }
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFile(File file, MessageTypeEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverUserId,
          messageEnum,
        );
  }

  void sendImageMessage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFile(image, MessageTypeEnum.image);
    }
  }

  void sendVideoMessage() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFile(video, MessageTypeEnum.video);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageTextController.dispose();
    _recorder.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              decoration: const BoxDecoration(
                color: mobileChatBoxColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageTextController,
                      onChanged: (value) {
                        setState(() {
                          isMessageEntered = value.isNotEmpty;
                        });
                      },
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your message..",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                  //if (!isMessageEntered)
                  const SizedBox(width: 12),
                  //if (!isMessageEntered)
                  BottomChatIconButton(
                    iconData: Icons.camera_alt,
                    onPressed: sendImageMessage,
                  ),
                  //if (!isMessageEntered)
                  BottomChatIconButton(
                    iconData: Icons.attach_file,
                    onPressed: sendVideoMessage,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              _sendTextMessage();
            },
            child: CircleAvatar(
              backgroundColor: tabColor,
              radius: 24,
              child: isMessageEntered
                  ? const Icon(Icons.send)
                  : isRecording
                      ? const Icon(Icons.close)
                      : const Icon(Icons.mic),
            ),
          ),
        ],
      ),
    );
  }
}
