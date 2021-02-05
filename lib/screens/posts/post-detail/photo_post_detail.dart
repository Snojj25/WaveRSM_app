import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';

import '../../../models/post.dart';

class PhotoDetailScreen extends StatelessWidget {
  final Post post;
  const PhotoDetailScreen({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Detail"),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo[900], Colors.grey[900]],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                post.title,
                textScaleFactor: 2,
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 20),
              // Container(
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.black, width: 10),
              //   ),
              //   child: Image.network(post.imgUrl),
              // ),
              FullScreenWidget(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(post.imgUrl),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 20, right: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    post.description,
                    textScaleFactor: 1.4,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
