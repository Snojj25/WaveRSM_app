import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forex_app/shared/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import './trades-screen-helpers/all_trades.dart';
import './trades-screen-helpers/image_labeler.dart' as img_labeler;
import '../../services/database.service.dart';
import '../../models/trade.model.dart';
import './trade_stats/trade_stats_screen.dart';
import '../../models/user.dart';
import '../../shared/app_drawer.dart';

List<Trade> allTrades = [];

class TradesScreen extends StatelessWidget {
  const TradesScreen({Key key, @required this.colorScheme}) : super(key: key);
  static const routeName = "trades-screen";
  final String colorScheme;

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor:
            colorScheme == "dark" ? Colors.black : Colors.grey[500],
        elevation: 0,
        iconTheme: IconThemeData(
            color: colorScheme == "dark" ? Colors.white : Colors.black),
        brightness: colorScheme == "dark" ? Brightness.dark : Brightness.light,
        title: Text(
          'Your Trades',
          style: TextStyle(
              color: colorScheme == "dark" ? Colors.white : Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.details),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (ctx) => TradeStatsScreen(
                          allTrades: allTrades, colorScheme: colorScheme),
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
      drawer:
          AppDrawer(colorScheme: colorScheme, userData: userData, active: 1),
      //  ================================================================
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colorScheme == "dark"
                ? [Colors.indigo[900], Colors.grey[900]]
                : [Colors.grey[500], Colors.white],
          ),
        ),
        child: img_labeler.TradeImageLabeler(),
      ),
      //  ================================================================
      bottomNavigationBar: BottomNavBar(colorScheme: colorScheme, activeIdx: 1),
      floatingActionButton: FloatingActionButton(onPressed: () {
        // setState(() {
        //   if (isModalOpen) {
        //     removeOverlay(context);
        //   } else {
        //     showOverlay(context);
        //   }
        //   isModalOpen = !isModalOpen;
        // });
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
