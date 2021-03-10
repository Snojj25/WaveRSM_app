import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:forex_app/shared/bottom_nav_bar.dart';

class ActivePosts extends StatefulWidget {
  ActivePosts({Key key}) : super(key: key);

  @override
  _ActivePostsState createState() => _ActivePostsState();
}

class _ActivePostsState extends State<ActivePosts> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                stretchModes: [StretchMode.fadeTitle],
                title: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "YOUR TRADE STATISTICS",
                    textScaleFactor: 1.1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.yellow[300],
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                            blurRadius: 3,
                            offset: Offset(2, 2),
                            color: Colors.black87)
                      ],
                    ),
                  ),
                ),
                background: Image.asset(
                  "assets/stock_photos/stock_image5.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.indigo[900],
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    boxShadow: [
                      BoxShadow(color: Colors.yellow[600], blurRadius: 1),
                    ],
                  ),
                  child: Wrap(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 4 / 3,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.easeInCubic,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              activeIndex = index;
                            });
                            print("index: " + index.toString());
                            print("reason: " + reason.toString());
                          },
                        ),
                        items: [
                          Container(
                            child: Image(
                              image: AssetImage(
                                  "assets/stock_photos/stock_image1.jpg"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            child: Image(
                              image: AssetImage(
                                  "assets/stock_photos/stock_image4.jpg"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            child: Image(
                              image: AssetImage(
                                  "assets/stock_photos/stock_image5.jpg"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            child: Image(
                              image: AssetImage(
                                  "assets/stock_photos/stock_image8.jpg"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            child: Image(
                              image: AssetImage(
                                  "assets/stock_photos/stock_image9.jpg"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(2),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          activeIndex.toString() +
                              " " +
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                          textScaleFactor: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(colorScheme: "dark", activeIdx: 1),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.close,
          size: 40,
        ),
        onPressed: () {},
      ),
    );
  }
}
