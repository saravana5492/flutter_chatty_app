import 'package:chatty/common/utils/utils.dart';
import 'package:chatty/common/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoMessageItem extends StatefulWidget {
  const VideoMessageItem({
    super.key,
    required this.videoUrl,
  });

  final String videoUrl;

  @override
  State<VideoMessageItem> createState() => _VideoMessageItemState();
}

class _VideoMessageItemState extends State<VideoMessageItem> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initialisePlayer();
  }

  void _initialisePlayer() async {
    final fileInfo = await checkCacheFor(widget.videoUrl);
    if (fileInfo == null) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..initialize().then((_) {
          cachedForUrl(widget.videoUrl);
          _controller!.setVolume(1);
          _controller!.addListener(checkVideoStatus);
          setState(() {});
        });
    } else {
      final file = fileInfo.file;
      _controller = VideoPlayerController.file(file);
      _controller!.initialize().then((_) {
        _controller!.setVolume(1);
        _controller!.addListener(checkVideoStatus);
        setState(() {});
      });
    }
  }

  checkVideoStatus() {
    if (_controller != null) {
      if (_controller!.value.position == _controller!.value.duration) {
        _controller!.seekTo(Duration.zero);
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_controller == null)
        ? const Loader()
        : Container(
            child: _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: Stack(
                      children: [
                        VideoPlayer(_controller!),
                        Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _controller!.value.isPlaying
                                    ? _controller!.pause()
                                    : _controller!.play();
                              });
                            },
                            icon: Icon(
                              _controller!.value.isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          );
  }
}
