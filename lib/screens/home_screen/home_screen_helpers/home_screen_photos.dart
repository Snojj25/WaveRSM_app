import 'package:flutter/material.dart';
import 'package:forex_app/screens/posts/post-detail/photo_post_detail.dart';

import '../../../models/post.dart';
import '../../../services/database.service.dart';

class HomeScreenPhotos extends StatefulWidget {
  HomeScreenPhotos({Key key, this.colorScheme}) : super(key: key);
  final String colorScheme;

  @override
  _HomeScreenPhotosState createState() => _HomeScreenPhotosState();
}

class _HomeScreenPhotosState extends State<HomeScreenPhotos> {
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
      stream: DataBaseService().photoPosts,
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
                child: Container(
                  child: PhotoContainer(post: snapshot.data[idx]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ! ==========================================================
// ! ==========================================================

class PhotoContainer extends StatefulWidget {
  final Post post;
  PhotoContainer({Key key, @required this.post}) : super(key: key);

  @override
  _PhotoContainerState createState() => _PhotoContainerState();
}

class _PhotoContainerState extends State<PhotoContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context)
        //     .pushNamed(PostDetailScreen.routeName)
        //     .catchError((err) {
        //   print("error navigating to post detail: " + err);
        // });
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PhotoDetailScreen(post: widget.post),
          ));
        },
        child: Container(
          child: Column(
            children: [
              ListTile(
                title: Text(widget.post.title),
              ),
              Container(
                child: Image.network(widget.post.imgUrl),
              ),
              ListTile(
                title: Text(checkLength(widget.post.description)),
              ),
            ],
          ),
        ),
      ),
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

// class CustomHalfCircleClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final Path path = new Path();
//     path.lineTo(0.0, size.height / 2);
//     path.lineTo(size.width, size.height / 2);
//     path.lineTo(size.width, 0);
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }
