enum MessageTypeEnum {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const MessageTypeEnum(this.type);
  final String type;
}

extension ConvertMessage on String {
  MessageTypeEnum toEnum() {
    switch (this) {
      case 'text':
        return MessageTypeEnum.text;
      case 'audio':
        return MessageTypeEnum.audio;
      case 'video':
        return MessageTypeEnum.video;
      case 'image':
        return MessageTypeEnum.image;
      case 'gif':
        return MessageTypeEnum.text;
      default:
        return MessageTypeEnum.text;
    }
  }
}
