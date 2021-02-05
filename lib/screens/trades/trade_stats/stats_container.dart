import 'package:flutter/material.dart';

import 'package:forex_app/models/trade.model.dart';

class StatsContainer extends StatelessWidget {
  final TradeStats tradeStats;
  final String colorScheme;
  const StatsContainer(
      {Key key, @required this.tradeStats, @required this.colorScheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              "TRADE STATISTICS",
              style: TextStyle(
                color: colorScheme == "dark" ? Colors.white : Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colorScheme == "dark"
                    ? [Colors.black, Colors.indigo[900]]
                    : [Colors.white, Colors.grey[600]],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // ? FIRST ROW =========================================================
          // UPPER
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatisticsTextContainer(
                  text: "Total trades:",
                  color: colorScheme == "dark"
                      ? Colors.blue[100]
                      : Colors.blue[900],
                ),
                StatisticsTextContainer(
                  text: "Positive trades:",
                  color: colorScheme == "dark"
                      ? Colors.green[200]
                      : Colors.green[800],
                ),
                StatisticsTextContainer(
                  text: "negative trades:",
                  color:
                      colorScheme == "dark" ? Colors.red[200] : Colors.red[900],
                ),
              ],
            ),
          ),
          // BOTTOM
          Container(
            margin:
                const EdgeInsets.only(bottom: 20, left: 2, right: 2, top: 0),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: colorScheme == "dark"
                    ? [Colors.black, Colors.indigo[900]]
                    : [Colors.white, Colors.grey[500]],
              ),
            ),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Total trades
                StatisticsTextContainer(
                  text: tradeStats.totalTrades.toString(),
                  color: colorScheme == "dark"
                      ? Colors.blue[100]
                      : Colors.blue[900],
                ),
                // Positive trades
                StatisticsTextContainer(
                  text: tradeStats.positiveTrades.toString(),
                  color: colorScheme == "dark"
                      ? Colors.green[200]
                      : Colors.green[800],
                ),
                // negative trades
                StatisticsTextContainer(
                  text: tradeStats.negativeTrades.toString(),
                  color:
                      colorScheme == "dark" ? Colors.red[200] : Colors.red[900],
                ),
              ],
            ),
          ),
          // ?  ===================================================================
          // ! SECOND ROW =========================================================
          // UPPER
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatisticsTextContainer(
                  text: "Total profit:",
                  color: colorScheme == "dark"
                      ? Colors.blue[100]
                      : Colors.blue[900],
                ),
                StatisticsTextContainer(
                  text: "total positive:",
                  color: colorScheme == "dark"
                      ? Colors.green[200]
                      : Colors.green[800],
                ),
                StatisticsTextContainer(
                  text: "total negative:",
                  color:
                      colorScheme == "dark" ? Colors.red[200] : Colors.red[900],
                ),
              ],
            ),
          ),
          // BOTTOM
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: colorScheme == "dark"
                    ? [Colors.black, Colors.indigo[900]]
                    : [Colors.white, Colors.grey[500]],
              ),
            ),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Total profit
                StatisticsTextContainer(
                  text: tradeStats.profit.toString(),
                  color: colorScheme == "dark"
                      ? Colors.blue[100]
                      : Colors.blue[900],
                ),
                // total positive
                StatisticsTextContainer(
                  text: tradeStats.positiveTotal.toString(),
                  color: colorScheme == "dark"
                      ? Colors.green[200]
                      : Colors.green[800],
                ),
                // total negative
                StatisticsTextContainer(
                  text: tradeStats.negativeTotal.toString(),
                  color:
                      colorScheme == "dark" ? Colors.red[200] : Colors.red[900],
                ),
              ],
            ),
          ),
          // !  ===================================================================
          // * THIRD ROW ==========================================================
          // UPPER
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatisticsTextContainer(
                  text: "Average profit:",
                  color: colorScheme == "dark"
                      ? Colors.blue[100]
                      : Colors.blue[900],
                ),
                StatisticsTextContainer(
                  text: "Average positive:",
                  color: colorScheme == "dark"
                      ? Colors.green[200]
                      : Colors.green[800],
                ),
                StatisticsTextContainer(
                  text: "Average negative:",
                  color:
                      colorScheme == "dark" ? Colors.red[200] : Colors.red[900],
                ),
              ],
            ),
          ),
          // BOTTOM
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: colorScheme == "dark"
                    ? [Colors.black, Colors.indigo[900]]
                    : [Colors.white, Colors.grey[500]],
              ),
            ),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Average profit
                StatisticsTextContainer(
                  text: (tradeStats.profit / tradeStats.totalTrades)
                      .toStringAsFixed(2),
                  color: colorScheme == "dark"
                      ? Colors.blue[100]
                      : Colors.blue[900],
                ),
                // Average positive
                StatisticsTextContainer(
                  text: (tradeStats.positiveTotal / tradeStats.positiveTrades)
                      .toStringAsFixed(2),
                  color: colorScheme == "dark"
                      ? Colors.green[200]
                      : Colors.green[800],
                ),
                // Average negative
                StatisticsTextContainer(
                  text: (tradeStats.negativeTotal / tradeStats.negativeTrades)
                      .toStringAsFixed(2),
                  color:
                      colorScheme == "dark" ? Colors.red[200] : Colors.red[900],
                ),
              ],
            ),
          ),
          // *  ===================================================================
          // & FOURTH ROW =========================================================
          // UPPER
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatisticsTextContainer(
                  text: "% positive trades:",
                  color: colorScheme == "dark"
                      ? Colors.green[200]
                      : Colors.green[800],
                ),
                StatisticsTextContainer(
                  text: "% negative trades:",
                  color:
                      colorScheme == "dark" ? Colors.red[200] : Colors.red[900],
                ),
              ],
            ),
          ),
          // BOTTOM
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: colorScheme == "dark"
                    ? [Colors.black, Colors.indigo[900]]
                    : [Colors.white, Colors.grey[500]],
              ),
            ),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // % positive trades
                StatisticsTextContainer(
                  text: ((tradeStats.positiveTrades / tradeStats.totalTrades) *
                              100)
                          .toStringAsFixed(1) +
                      "%",
                  color: colorScheme == "dark"
                      ? Colors.green[200]
                      : Colors.green[800],
                ),
                // % negative trades
                StatisticsTextContainer(
                  text: ((tradeStats.negativeTrades / tradeStats.totalTrades) *
                              100)
                          .toStringAsFixed(1) +
                      "%",
                  color:
                      colorScheme == "dark" ? Colors.red[200] : Colors.red[900],
                ),
              ],
            ),
          ),
          // &  ===================================================================
        ],
      ),
    );
  }
}

class StatisticsTextContainer extends StatelessWidget {
  final String text;
  final Color color;
  const StatisticsTextContainer({Key key, @required this.text, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
            // border: Border.all(width: 5),
            ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color != null ? color : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
