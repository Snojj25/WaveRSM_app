import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/post.dart';
import './models/user.dart';
import './screens/authenticate/login_screen.dart';
import './screens/authenticate/register_screen.dart';
import './screens/posts/new_post.dart';
import './screens/settings/settings_screen.dart';
import './screens/wrapper.dart';
import './services/auth.service.dart';
import 'screens/home_screen/home_screen.dart';
import './services/database.service.dart';
import './services/ml_vision.service.dart';
import './screens/trades/trades_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: AuthService().user,
        ),
        StreamProvider<List<Trade>>.value(
          value: DataBaseServce().trades,
        ),
        StreamProvider<UserData>.value(
          value: DataBaseServce().userData,
        ),
        StreamProvider<List<Post>>.value(
          value: DataBaseServce().posts,
        ),
      ],
      child: MaterialApp(
        title: 'Forex app',
        theme: ThemeData(
          typography: Typography.material2018(
            black: Typography.blackHelsinki,
            white: Typography.whiteMountainView,
          ),
          cursorColor: Colors.white,
          hintColor: Colors.white60,
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.grey[600]),
            bodyText2: TextStyle(color: Colors.grey[600]),
          ),
          backgroundColor: Colors.indigo[900],
          primaryColor: Colors.black,
          primaryColorDark: Colors.indigo[900],
          primaryColorLight: Colors.grey[800],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper(),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          TradesScreen.routeName: (ctx) => TradesScreen(),
          RegisterProfileScreen.routeName: (ctx) => RegisterProfileScreen(),
          SignIn.routeName: (ctx) => SignIn(),
          NewPost.routeName: (ctx) => NewPost(),
        },
      ),
    );
  }
}
