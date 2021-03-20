import 'package:flutter/material.dart';
import 'package:forex_app/services/database.service.dart';
import 'package:forex_app/shared/errors.dart';
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
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300].withOpacity(0.1),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Text(
                    post.description,
                    textScaleFactor: 1.4,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                ),
              ),
              ButtonBar(
                children: [
                  SetActiveButton(post: post, mode: "photos"),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
class SetActiveButton extends StatefulWidget {
  final Post post;
  final String mode;
  SetActiveButton({Key key, @required this.post, @required this.mode})
      : super(key: key);

  @override
  _SetActiveButtonState createState() => _SetActiveButtonState();
}

class _SetActiveButtonState extends State<SetActiveButton>
    with SingleTickerProviderStateMixin {
  bool _isActive = false;

  AnimationController _controller;
  Animation<double> _animation;

  final _dbService = DataBaseService();

  @override
  void initState() {
    _dbService.checkIfActive(widget.post.id, widget.mode).then((isActive) {
      print(isActive);
      setState(() {
        _isActive = isActive;
      });
    }).catchError((err) {
      print("in error haha");
      showErrorDialog(context, err, "dark");
    });
    // ===============
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 25).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => IconButton(
            padding: EdgeInsets.only(left: 0.9 * _animation.value),
            iconSize: 40 + _animation.value,
            icon: Icon(
              _isActive ? Icons.star_rounded : Icons.star_outline_rounded,
              color: Colors.yellow,
            ),
            onPressed: () async {
              print(_isActive);
              setState(() {
                _controller.forward().whenComplete(() {
                  _controller.reverse();
                });
                _isActive = !_isActive;
              });
              if (_isActive) {
                DataBaseService().setActive(widget.post.id, "photos").then((_) {
                  print("post with uid: " + widget.post.id + " set to active.");
                }).catchError((err) {
                  showErrorDialog(context, err, "dark");
                });
              } else {
                DataBaseService()
                    .removeActive(widget.post.id, "photos")
                    .then((_) {
                  print("post with uid: " +
                      widget.post.id +
                      " set to not active.");
                }).catchError((err) {
                  showErrorDialog(context, err, "dark");
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
