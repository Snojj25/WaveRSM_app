import 'package:flutter/material.dart';
import 'package:forex_app/models/post.dart';
import 'package:forex_app/screens/posts/post-detail/photo_post_detail.dart';

class ActiveTradesDescriptionContainer extends StatelessWidget {
  final int activeIdx;
  final List<Post> activePosts;
  const ActiveTradesDescriptionContainer(
      {Key key, @required this.activeIdx, @required this.activePosts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              activeIdx.toString() + " " + activePosts[activeIdx].description,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              textScaleFactor: 1.3,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PhotoDetailScreen(post: activePosts[activeIdx]),
                      ));
                    },
                    elevation: 2.0,
                    fillColor: Colors.grey,
                    child: Icon(
                      Icons.arrow_forward,
                      size: 40.0,
                      color: Colors.black,
                    ),
                    padding: EdgeInsets.all(5.0),
                    shape: CircleBorder(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
