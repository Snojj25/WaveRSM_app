import 'package:flutter/material.dart';
import 'package:forex_app/models/post.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetailScreen extends StatefulWidget {
  final Post post;
  const VideoDetailScreen({Key key, this.post}) : super(key: key);
  static const routeName = "/video-detail-screen";

  @override
  _VideoDetailScreenState createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    String initVidId = YoutubePlayer.convertUrlToId(widget.post.imgUrl);
    _controller = YoutubePlayerController(
      initialVideoId: initVidId,
      flags: const YoutubePlayerFlags(
        controlsVisibleAtStart: true,
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape) {
          return Scaffold(
            body: youtubeHierarchy(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text("Title"),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo[900], Colors.grey[900]],
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      widget.post.title,
                      textScaleFactor: 2,
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w900),
                    ),
                  ),
                  youtubeHierarchy(),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25, left: 25, right: 15),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.post.description,
                        textScaleFactor: 1.5,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }

  youtubeHierarchy() {
    return Container(
      child: YoutubePlayer(
        controller: _controller,
        progressColors: ProgressBarColors(
            backgroundColor: Colors.indigo[900],
            bufferedColor: Colors.indigo[900],
            handleColor: Colors.blue,
            playedColor: Colors.blue),
        showVideoProgressIndicator: true,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // IconButton(
          //   icon: const Icon(
          //     Icons.settings,
          //     color: Colors.white,
          //     size: 25.0,
          //   ),
          //   onPressed: () {
          //     print('Settings Tapped!');
          //   },
          // ),
        ],
      ),
    );
  }
}
