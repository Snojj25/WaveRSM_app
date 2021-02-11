import 'package:flutter/material.dart';
import 'package:forex_app/screens/posts/post-detail/video_post_detail.dart';
import '../../../models/post.dart';
import '../../../services/database.service.dart';
// import '../../../shared/video_player.dart';

class HomeScreenVideos extends StatefulWidget {
  HomeScreenVideos({Key key, this.colorScheme}) : super(key: key);
  final String colorScheme;

  @override
  _HomeScreenVideosState createState() => _HomeScreenVideosState();
}

class _HomeScreenVideosState extends State<HomeScreenVideos> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.center,
          child: Text(
            "ANALYSES",
            textScaleFactor: 1.7,
            style: TextStyle(
                color: widget.colorScheme == "dark"
                    ? Colors.grey[300]
                    : Colors.indigo[900]),
          ),
        ),
        Expanded(child: AnalysesList()),
      ],
    );
  }
}

class AnalysesList extends StatefulWidget {
  const AnalysesList({Key key}) : super(key: key);

  @override
  _AnalysesListState createState() => _AnalysesListState();
}

class _AnalysesListState extends State<AnalysesList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataBaseService().videoPosts,
      builder: (BuildContext ctx, AsyncSnapshot<List<Post>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Text("nothing to show"),
          );
        }
        return Container(
          margin: const EdgeInsets.all(10),
          height: double.maxFinite,
          child: ListView.builder(
            addAutomaticKeepAlives: true,
            cacheExtent: 10,
            itemCount: snapshot.data.length,
            itemBuilder: (ctx, idx) {
              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black, spreadRadius: 3)
                    ],
                    color: Colors.grey[400]),
                child: VideoContainer(post: snapshot.data[idx]),
              );
            },
          ),
        );
      },
    );
  }
}

// ! =========================================================
//! ==========================================================

class VideoContainer extends StatefulWidget {
  final Post post;
  VideoContainer({Key key, @required this.post}) : super(key: key);

  @override
  _VideoContainerState createState() => _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer> {
  @override
  Widget build(BuildContext context) {
    // final VideoControllerWrapper videoControllerWrapper =
    //     VideoControllerWrapper(
    //         DataSource.network(widget.post.imgUrl, displayName: "displayName"));
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VideoDetailScreen(post: widget.post),
              ),
            );
          },
          title: Text(widget.post.title),
        ),
        Container(
          color: Colors.red,
          child: Text("HELLO"),
          // child: CustomVideoPlayer(),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VideoDetailScreen(post: widget.post),
              ),
            );
          },
          title: Text(checkLength(widget.post.description)),
          hoverColor: Colors.green,
        ),
      ],
    );
  }
}

String checkLength(String string) {
  List<String> arr = string.split(" ");
  if (arr.length > 30) {
    return arr.take(30).join(" ") + "...";
  } else {
    return string;
  }
}

// ! =========================================================
