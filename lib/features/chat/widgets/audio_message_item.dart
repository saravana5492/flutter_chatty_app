import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioMessageItem extends StatefulWidget {
  const AudioMessageItem({super.key, required this.message});

  final String message;

  @override
  State<AudioMessageItem> createState() => _AudioMessageItemState();
}

class _AudioMessageItemState extends State<AudioMessageItem> {
  var isPlaying = false;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _refreshPlayer();
  }

  void _refreshPlayer() {
    player.onPlayerComplete.listen((_) {
      player.seek(Duration.zero);
      setState(() {
        isPlaying = !isPlaying;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: const BoxConstraints(
        minWidth: 110,
      ),
      onPressed: () async {
        if (isPlaying) {
          player.stop();
          setState(() {
            isPlaying = false;
          });
        } else {
          await player.play(UrlSource(widget.message));
          setState(() {
            isPlaying = true;
          });
        }
      },
      icon: (isPlaying)
          ? const Icon(Icons.pause_circle)
          : const Icon(Icons.play_circle),
    );
  }
}
