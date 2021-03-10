// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import 'package:forex_app/models/trade.model.dart';
import 'package:forex_app/screens/trades/trade_stats/stats_container.dart';

import 'charts/chart_helpers.dart';
import '../../../services/database.service.dart';
import 'charts/first_chart.dart';

class TradeStatsScreen extends StatefulWidget {
  final List<Trade> allTrades;
  final String colorScheme;
  const TradeStatsScreen({
    Key key,
    @required this.allTrades,
    @required this.colorScheme,
  }) : super(key: key);
  static const routeName = "/trade-stats-screen";

  @override
  _TradeStatsScreenState createState() => _TradeStatsScreenState();
}

class _TradeStatsScreenState extends State<TradeStatsScreen> {
  String _uid;
  final dbService = DataBaseService();

  @override
  void initState() {
    this._uid = GlobalConfiguration().getValue("uid");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext ctx, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 0.2 * height,
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
                        color: widget.colorScheme == "dark"
                            ? Colors.yellow[300]
                            : Colors.black,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                              blurRadius: 3,
                              offset: Offset(2, 2),
                              color: Colors.black87)
                        ]),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ? FIRST CHART STRAT ================================
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  height: 0.8 * height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.colorScheme == "dark"
                          ? [Colors.black, Colors.indigo[900]]
                          : [Colors.grey[500], Colors.white],
                      // [
                      //   Colors.black,
                      //   Colors.indigo[900],
                      // ],
                      begin: Alignment.topRight,
                    ),
                  ),
                  child: ProfitByMonthChart(
                      allTrades: widget.allTrades,
                      colorScheme: widget.colorScheme),
                ),
                // ? FIRST CHART END ====================================
                // ! SECOND CHART START =================================
                Container(
                  padding: EdgeInsets.symmetric(vertical: 0.07 * height),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.colorScheme == "dark"
                          ? [Colors.black, Colors.indigo[900]]
                          : [Colors.grey[500], Colors.white],
                      begin: Alignment.topRight,
                    ),
                  ),
                  height: 0.9 * height,
                  child: SymbolProfitChart(
                    allTrades: widget.allTrades,
                    colorScheme: widget.colorScheme,
                  ),
                ),
                // ! SECOND CHART END ====================================
                // & THIRD CHART START ===================================
                FutureBuilder(
                    future: dbService.getUserTradeStats(_uid),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 0.07 * height),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: widget.colorScheme == "dark"
                                  ? [Colors.black, Colors.indigo[900]]
                                  : [Colors.grey[500], Colors.white],
                              begin: Alignment.topRight,
                            ),
                          ),
                          width: double.infinity,
                          // height: 0.9 * height,
                          child: StatsContainer(
                              tradeStats: snapshot.data,
                              colorScheme: widget.colorScheme),
                        );
                      }
                    }),
                // & THIRD CHART END =====================================
              ],
            ),
          ),
        ),
      ),
    );
  }
  // ================================================

}

// RaisedButton(
//                 child: Text("Test"),
//                 onPressed: () {
//                   final List<String> symbols = [
//                     "GBPCAD",
//                     "EURUSD",
//                     "CHFNZD",
//                     "AUDJPY",
//                     "GBPCHF",
//                     "EURCAD",
//                     "USDJPY",
//                     "AUDNZD"
//                   ];
//                   for (var i = 0; i < 8; i++) {
//                     for (var j = 0; j < 10; j++) {
//                       final trade = new Trade(
//                         dateTime: DateTime.now().subtract(
//                           j % 4 == 0
//                               ? new Duration(days: 5 + i + j)
//                               : new Duration(days: 7 + i + j),
//                         ),
//                         entry: Random().nextDouble(),
//                         exit: Random().nextDouble(),
//                         profit: ((6 + i) / 13) *
//                             Random().nextInt(50).roundToDouble() *
//                             pow(-1, j),
//                         lotSize: 0.07,
//                         tradeType: j % 2 == 0 ? "Buy" : "Sell",
//                         symbol: symbols[i],
//                       );
//                       // dbService
//                       //     .addTrade(trade, _uid)
//                       //     .then((value) => {
//                       //           print("added " + i.toString()),
//                       //         })
//                       //     .catchError((err) {
//                       //   print(err);
//                       //   return;
//                       // });
//                     }
//                   }
//                 },
//               ),
