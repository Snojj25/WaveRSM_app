import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const CustomVideoPlayer({
    @required this.videoPlayerController,
    Key key,
  }) : super(key: key);

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  ChewieController _chewiecontroller;

  @override
  void initState() {
    super.initState();
    _chewiecontroller = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: widget.videoPlayerController.value.aspectRatio,
      autoInitialize: true,
      allowFullScreen: true,
      allowMuting: true,
      allowedScreenSleep: false,
      errorBuilder: (context, errorMessage) => Center(
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: _chewiecontroller,
      ),
    );
  }
}
