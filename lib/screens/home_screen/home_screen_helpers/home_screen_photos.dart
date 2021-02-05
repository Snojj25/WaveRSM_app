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
  bool isModalOpen = false;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.colorScheme == "dark"
              ? [Colors.indigo[900], Colors.grey[900]]
              : [Colors.grey[500], Colors.white],
        ),
      ),
      child: Stack(
        children: [
          Container(
            foregroundDecoration: isModalOpen
                ? BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5))
                : null,
            child: Column(
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
            ),
          ),
          Positioned(
            top: 8,
            right: 27,
            child: AnimatedContainer(
              // width: isModalOpen ? 0.2 * width : 0.0,
              width: 0.18 * width,
              height: isModalOpen ? 0.5 * height : 0.0,
              decoration: BoxDecoration(
                color: isModalOpen ? Colors.indigo[800] : Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              duration: Duration(seconds: 1),
              curve: Curves.decelerate,
              child: isModalOpen
                  ? Wrap(
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.center,
                      direction: Axis.vertical,
                      spacing: 25,
                      children: [
                        IconButton(
                            icon: Icon(Icons.gavel,
                                color: Colors.white, size: 40),
                            onPressed: () {
                              print("pressed");
                            }),
                        IconButton(
                            icon: Icon(Icons.fastfood,
                                color: Colors.white, size: 40),
                            onPressed: () {
                              print("pressed");
                            }),
                        IconButton(
                            icon: Icon(Icons.outlined_flag,
                                color: Colors.white, size: 40),
                            onPressed: () {
                              print("pressed");
                            }),
                      ],
                    )
                  : null,
            ),
          ),
          Positioned(
            top: 8,
            right: 20,
            child: RawMaterialButton(
              onPressed: () {
                setState(() {
                  isModalOpen = !isModalOpen;
                });
              },
              elevation: 2.0,
              fillColor: Colors.white,
              child: Icon(
                isModalOpen
                    ? Icons.keyboard_arrow_up
                    // : Icons.keyboard_arrow_down,
                    // : Icons.clear_all,
                    : Icons.dehaze,
                size: 40.0,
                color: Colors.black,
              ),
              padding: EdgeInsets.all(10.0),
              shape: CircleBorder(),
            ),
          ),
        ],
      ),
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
