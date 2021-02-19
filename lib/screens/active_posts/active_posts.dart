import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ActivePosts extends StatefulWidget {
  ActivePosts({Key key}) : super(key: key);

  @override
  _ActivePostsState createState() => _ActivePostsState();
}

class _ActivePostsState extends State<ActivePosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Active trades"),
      ),
      body: Container(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2)),
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 4 / 3,
                viewportFraction: 0.99,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 2),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.easeInCubic,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items: [
                Container(
                  color: Colors.red,
                  child: Image(
                    image: AssetImage("assets/stock_photos/stock_image1.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  color: Colors.green,
                  child: Image(
                    image: AssetImage("assets/stock_photos/stock_image4.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  color: Colors.blue,
                  child: Image(
                    image: AssetImage("assets/stock_photos/stock_image5.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  color: Colors.orange,
                  child: Image(
                    image: AssetImage("assets/stock_photos/stock_image8.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  color: Colors.yellow,
                  child: Image(
                    image: AssetImage("assets/stock_photos/stock_image9.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
