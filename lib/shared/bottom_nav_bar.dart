import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:forex_app/screens/active_posts/active_posts.dart';
import 'package:forex_app/screens/home_screen/home_screen.dart';
import 'package:forex_app/screens/settings/settings_screen.dart';
import 'package:forex_app/screens/trades/trades_screen.dart';

class BottomNavBar extends StatefulWidget {
  final String colorScheme;
  final int activeIdx;
  BottomNavBar({Key key, @required this.colorScheme, @required this.activeIdx})
      : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<IconData> _iconList = [
    Icons.home,
    Icons.show_chart,
    Icons.high_quality,
    Icons.settings
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[900], Colors.black],
        ),
      ),
      child: Container(
        // ? CONTAINER WRAPPERS ==========
        // * ANIMATED CONTAINER =======
        child: AnimatedBottomNavigationBar.builder(
          itemCount: _iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? Colors.blue[400] : Colors.white;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _iconList[index],
                  size: 35,
                  color: color,
                ),
                SizedBox(width: 2),
                isActive
                    ? Text(
                        "Home",
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.w700),
                      )
                    : Container(height: 0)
              ],
            );
          },
          backgroundColor: Colors.blue[800],
          activeIndex: widget.activeIdx,
          splashColor: Colors.purple,
          splashRadius: 0,
          // notchAndCornersAnimation: null,
          // elevation: 25,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.smoothEdge,
          gapLocation: GapLocation.center,
          gapWidth: 0.1 * width,
          leftCornerRadius: 15,
          rightCornerRadius: 15,
          onTap: (index) => setState(
            () => {
              if (index == 0)
                {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: RotationTransition(
                              turns: secondaryAnimation,
                              child: child,
                            ),
                          ),
                        );
                        // SizeTransition(sizeFactor: animation);
                      },
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return HomeScreen();
                      },
                      transitionDuration: Duration(milliseconds: 850),
                    ),
                  )
                }
              else if (index == 1)
                {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: RotationTransition(
                              turns: secondaryAnimation,
                              child: child,
                            ),
                          ),
                        );
                        // SizeTransition(sizeFactor: animation);
                      },
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return ActivePosts();
                      },
                      transitionDuration: Duration(milliseconds: 850),
                    ),
                  )
                }
              else if (index == 2)
                {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: RotationTransition(
                              turns: secondaryAnimation,
                              child: child,
                            ),
                          ),
                        );
                        // SizeTransition(sizeFactor: animation);
                      },
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return TradesScreen(colorScheme: widget.colorScheme);
                      },
                      transitionDuration: Duration(milliseconds: 850),
                    ),
                  )
                }
              else if (index == 3)
                {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: RotationTransition(
                              turns: secondaryAnimation,
                              child: child,
                            ),
                          ),
                        );
                        // SizeTransition(sizeFactor: animation);
                      },
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return SettingsScreen();
                      },
                      transitionDuration: Duration(milliseconds: 850),
                    ),
                  )
                }
            },
          ),
        ),
      ),
    );
  }
}
