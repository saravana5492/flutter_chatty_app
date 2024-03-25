import 'package:flutter/material.dart';

class BottomChatIconButton extends StatelessWidget {
  const BottomChatIconButton({
    super.key,
    required this.iconData,
    required this.onPressed,
  });

  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      width: 32,
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: onPressed,
        icon: Icon(
          iconData,
          color: Colors.grey,
        ),
      ),
    );
  }
}
