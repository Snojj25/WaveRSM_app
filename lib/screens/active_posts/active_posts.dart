import 'package:flutter/material.dart';
import 'package:forex_app/models/post.dart';
import 'package:forex_app/screens/active_posts/active_posts_utils/description_container.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:forex_app/services/database.service.dart';
import 'package:forex_app/shared/bottom_nav_bar.dart';
import 'package:forex_app/shared/errors.dart';

class ActivePosts extends StatefulWidget {
  ActivePosts({Key key}) : super(key: key);

  @override
  _ActivePostsState createState() => _ActivePostsState();
}

class _ActivePostsState extends State<ActivePosts> {
  bool isLoading = true;

  int activeIndex = 0;
  List<Post> _activePosts = [];

  final _dbService = DataBaseService();

  @override
  void initState() {
    _dbService.getActivePosts().then((activePosts) {
      _activePosts = activePosts;
    }).catchError((err) {
      showErrorDialog(context, err, "dark");
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250,
              floating: true,
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
        body: isLoading == true
            ? CircularProgressIndicator()
            : Container(
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
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Wrap(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.yellow[600], blurRadius: 1),
                                ],
                              ),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  aspectRatio: 4 / 3,
                                  viewportFraction: 1,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 20),
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
                                      image:
                                          NetworkImage(_activePosts[0].imgUrl),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    child: Image(
                                      image:
                                          NetworkImage(_activePosts[1].imgUrl),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    child: Image(
                                      image:
                                          NetworkImage(_activePosts[2].imgUrl),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    child: Image(
                                      image:
                                          NetworkImage(_activePosts[0].imgUrl),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    child: Image(
                                      image:
                                          NetworkImage(_activePosts[1].imgUrl),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(height: 40, color: Colors.grey[700]),
                            ActiveTradesDescriptionContainer(
                              activeIdx: activeIndex,
                              activePosts: _activePosts,
                            ),
                          ],
                        ),
                      ],
                    ),
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
