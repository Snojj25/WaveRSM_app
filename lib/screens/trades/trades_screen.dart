import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forex_app/screens/settings/app_settings.config.dart';
import 'package:forex_app/shared/bottom_nav_bar.dart';
import 'package:forex_app/shared/overlays.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';

import './trades-screen-helpers/all_trades.dart';
import './trades-screen-helpers/image_labeler.dart' as img_labeler;
import '../../services/database.service.dart';
import '../../models/trade.model.dart';
import './trade_stats/trade_stats_screen.dart';
import '../../models/user.dart';
import '../../shared/app_drawer.dart';

List<Trade> allTrades = [];

class TradesScreen extends StatefulWidget {
  const TradesScreen({Key key, @required this.colorScheme}) : super(key: key);
  static const routeName = "trades-screen";
  final String colorScheme;

  @override
  _TradesScreenState createState() => _TradesScreenState();
}

class _TradesScreenState extends State<TradesScreen>
    with TickerProviderStateMixin {
  bool isLoading = true;
  String colorScheme;
  bool isModalOpen = false;

  List<OverlayEntry> _entries = [];

  AnimationController _positionController;
  Animation<double> _animation1;
  Animation<double> _animation2;
  Animation<double> _animation3;

  AnimationController _colorController;

  List<Animation> _animations;

  List<dynamic> _functions;

  List<IconData> _icons = [Icons.ac_unit, Icons.feedback, Icons.pie_chart];

  @override
  void initState() {
    // =====================================
    getColorScheme().then((value) {
      GlobalConfiguration().addValue("colorScheme", value);
      setState(() {
        colorScheme = value;
      });
    }).catchError((err) {
      print("error code: failed home screen init state color scheme set");
      print(err);
    });
    isLoading = false;
    // =====================================
    // =====================================
    _positionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animation1 = Tween<double>(begin: 1, end: 0.15).animate(
      CurvedAnimation(
        parent: _positionController,
        curve: Interval(0.0, 0.6, curve: Curves.decelerate),
      ),
    );
    _animation2 = Tween<double>(begin: 1, end: 0.08).animate(
      CurvedAnimation(
        parent: _positionController,
        curve: Interval(0.0, 0.8, curve: Curves.decelerate),
      ),
    );
    _animation3 = Tween<double>(begin: 1, end: 0.01).animate(
      CurvedAnimation(
        parent: _positionController,
        curve: Interval(0.0, 1.0, curve: Curves.decelerate),
      ),
    );
    // =====================================

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // =====================================
    _animations = [_animation1, _animation2, _animation3];
    void f1() {
      print("f1");
    }

    void f2() {
      print("f2");
    }

    void f3() {
      print("f3");
    }

    _functions = [f1, f2, f3];
    // =====================================

    super.initState();
  }

  @override
  void dispose() {
    if (_entries.isNotEmpty) {
      for (OverlayEntry entry in _entries) {
        entry.remove();
      }
    }
    _colorController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor:
            widget.colorScheme == "dark" ? Colors.black : Colors.grey[500],
        elevation: 0,
        iconTheme: IconThemeData(
            color: widget.colorScheme == "dark" ? Colors.white : Colors.black),
        brightness:
            widget.colorScheme == "dark" ? Brightness.dark : Brightness.light,
        title: Text(
          'Your Trades',
          style: TextStyle(
              color:
                  widget.colorScheme == "dark" ? Colors.white : Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.details),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (ctx) => TradeStatsScreen(
                          allTrades: allTrades,
                          colorScheme: widget.colorScheme),
                    ),
                  )
                  .catchError((err) => {
                        print("error navigating to Trade stats screen: " + err)
                      });
            },
          )
        ],
      ),
      //  ================================================================
      drawer: AppDrawer(
          colorScheme: widget.colorScheme, userData: userData, active: 1),
      //  ================================================================
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.colorScheme == "dark"
                ? [Colors.indigo[900], Colors.grey[900]]
                : [Colors.grey[500], Colors.white],
          ),
        ),
        child: img_labeler.TradeImageLabeler(),
      ),
      //  ================================================================
      bottomNavigationBar:
          BottomNavBar(colorScheme: widget.colorScheme, activeIdx: 2),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            isModalOpen ? Icons.close : Icons.view_headline,
            size: 40,
          ),
          onPressed: () {
            setState(() {
              if (isModalOpen) {
                removeOverlay(_positionController, _entries);
              } else {
                _entries = showOverlay(
                  context,
                  _positionController,
                  _colorController,
                  _animations,
                  _functions,
                  _icons,
                  colorScheme,
                );
              }
              isModalOpen = !isModalOpen;
            });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// ! ==========================================

class AllTrades extends StatelessWidget {
  const AllTrades({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataBaseService().trades,
      builder: (BuildContext ctx, AsyncSnapshot<List<Trade>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.data.length == 0) {
          return Center(
            child: Text(
              "You haven't added any trades yet.",
              textScaleFactor: 1.5,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
        } else {
          allTrades = snapshot.data;
          return AllTradesList(allTrades: snapshot.data);
        }
      },
    );
  }
}
