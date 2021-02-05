import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/trade.model.dart';
import 'charts/circular_symbol_chart.dart';
import 'charts/column_symbols_chart.dart';

// & 2. SYMBOL PROFIT CHART ==========================================
// & ================================================================

class SymbolProfitChart extends StatelessWidget {
  final String colorScheme;
  final List<Trade> allTrades;
  const SymbolProfitChart({
    Key key,
    @required this.allTrades,
    @required this.colorScheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: TabBarView(children: [
        DoubleSimbolPieChart(colorScheme: colorScheme),
        CircularSymbolChart(posNegAll: "all", colorScheme: colorScheme),
        ColumnSymbolChart(key: key, posNegAll: "all", colorScheme: colorScheme),
      ]),
      initialIndex: 1,
    );
  }
}

// & ================================================================
// & ================================================================

// ! HELPER FUNTIONS =================================================
// ! =================================================================

List<TradesDataByTime> getAllTradesProfit(List<Trade> _allTrades) {
  Map _tradesMap = {};
  _allTrades.forEach((Trade singleTrade) {
    final String formattedString =
        DateFormat("yyyy-MM-dd").format(singleTrade.dateTime);
    _tradesMap[formattedString] = _tradesMap[formattedString] == null
        ? singleTrade.profit
        : _tradesMap[formattedString] + singleTrade.profit;
  });
  List<TradesDataByTime> resutList = [];
  _tradesMap.forEach((key, value) {
    final TradesDataByTime tradesDataByTime =
        new TradesDataByTime(date: DateTime.parse(key), profit: value);
    resutList.add(tradesDataByTime);
  });
  resutList.sort((a, b) {
    return a.date.compareTo(b.date);
  });
  for (var i = 0; i < resutList.length - 1; i++) {
    if (resutList[i + 1].profit >= resutList[i].profit) {
      resutList[i].color = Colors.green;
    } else {
      resutList[i].color = Colors.red;
    }
  }
  return resutList;
}

// ===============================================

List<StatsDataSymbolType> getDataSourceSymbolProfit(
    List<Trade> _trades, String posNegAll) {
  final eurPairs =
      new StatsDataSymbolType(symbolType: "EUR", profit: 0.0, total: 0);
  final usdPairs =
      new StatsDataSymbolType(symbolType: "USD", profit: 0.0, total: 0);
  final gbpPairs =
      new StatsDataSymbolType(symbolType: "GBP", profit: 0.0, total: 0);
  final chfPairs =
      new StatsDataSymbolType(symbolType: "CHF", profit: 0.0, total: 0);
  final audPairs =
      new StatsDataSymbolType(symbolType: "AUD", profit: 0.0, total: 0);
  final cadPairs =
      new StatsDataSymbolType(symbolType: "CAD", profit: 0.0, total: 0);
  final jpyPairs =
      new StatsDataSymbolType(symbolType: "JPY", profit: 0.0, total: 0);
  final nzdPairs =
      new StatsDataSymbolType(symbolType: "NZD", profit: 0.0, total: 0);
  _trades.forEach((Trade singleTrade) {
    final String symbol = singleTrade.symbol;
    final double profit = singleTrade.profit;
    // EUR PAIRS
    if (symbol.contains("EUR")) {
      if (posNegAll == "positive" && profit >= 0) {
        eurPairs.profit =
            double.parse((eurPairs.profit + profit).toStringAsFixed(2));
        eurPairs.total += 1;
      } else if (posNegAll == "negative" && profit < 0) {
        eurPairs.profit =
            double.parse((eurPairs.profit + profit).toStringAsFixed(2));
        eurPairs.total += 1;
      } else if (posNegAll == "all") {
        eurPairs.profit =
            double.parse((eurPairs.profit + profit).toStringAsFixed(2));
        eurPairs.total += 1;
      }
    }
    // USD PAIRS
    if (symbol.contains("USD")) {
      if (posNegAll == "positive" && profit >= 0) {
        usdPairs.profit =
            double.parse((usdPairs.profit + profit).toStringAsFixed(2));
        usdPairs.total += 1;
      } else if (posNegAll == "negative" && profit < 0) {
        usdPairs.profit =
            double.parse((usdPairs.profit + profit).toStringAsFixed(2));
        usdPairs.total += 1;
      } else if (posNegAll == "all") {
        usdPairs.profit =
            double.parse((usdPairs.profit + profit).toStringAsFixed(2));
        usdPairs.total += 1;
      }
    }
    // GBP PAIRS
    if (symbol.contains("GBP")) {
      if (posNegAll == "positive" && profit >= 0) {
        gbpPairs.profit =
            double.parse((gbpPairs.profit + profit).toStringAsFixed(2));
        gbpPairs.total += 1;
      } else if (posNegAll == "negative" && profit < 0) {
        gbpPairs.profit =
            double.parse((gbpPairs.profit + profit).toStringAsFixed(2));
        gbpPairs.total += 1;
      } else if (posNegAll == "all") {
        gbpPairs.profit =
            double.parse((gbpPairs.profit + profit).toStringAsFixed(2));
        gbpPairs.total += 1;
      }
    }
    // CHF PAIRS
    if (symbol.contains("CHF")) {
      if (posNegAll == "positive" && profit >= 0) {
        chfPairs.profit =
            double.parse((chfPairs.profit + profit).toStringAsFixed(2));
        chfPairs.total += 1;
      } else if (posNegAll == "negative" && profit < 0) {
        chfPairs.profit =
            double.parse((chfPairs.profit + profit).toStringAsFixed(2));
        chfPairs.total += 1;
      } else if (posNegAll == "all") {
        chfPairs.profit =
            double.parse((chfPairs.profit + profit).toStringAsFixed(2));
        chfPairs.total += 1;
      }
    }
    // AUD PAIRS
    if (symbol.contains("AUD")) {
      if (posNegAll == "positive" && profit >= 0) {
        audPairs.profit =
            double.parse((audPairs.profit + profit).toStringAsFixed(2));
        audPairs.total += 1;
      } else if (posNegAll == "negative" && profit < 0) {
        audPairs.profit =
            double.parse((audPairs.profit + profit).toStringAsFixed(2));
        audPairs.total += 1;
      } else if (posNegAll == "all") {
        audPairs.profit =
            double.parse((audPairs.profit + profit).toStringAsFixed(2));
        audPairs.total += 1;
      }
    }
    // CAD PAIRS
    if (symbol.contains("CAD")) {
      if (posNegAll == "positive" && profit >= 0) {
        cadPairs.profit =
            double.parse((cadPairs.profit + profit).toStringAsFixed(2));
        cadPairs.total += 1;
      } else if (posNegAll == "negative" && profit < 0) {
        cadPairs.profit =
            double.parse((cadPairs.profit + profit).toStringAsFixed(2));
        cadPairs.total += 1;
      } else if (posNegAll == "all") {
        cadPairs.profit =
            double.parse((cadPairs.profit + profit).toStringAsFixed(2));
        cadPairs.total += 1;
      }
    }
    // JPY PAIRS
    if (symbol.contains("JPY")) {
      if (posNegAll == "positive" && profit >= 0) {
        jpyPairs.profit =
            double.parse((jpyPairs.profit + profit).toStringAsFixed(2));
        jpyPairs.total += 1;
      } else if (posNegAll == "negative" && profit < 0) {
        jpyPairs.profit =
            double.parse((jpyPairs.profit + profit).toStringAsFixed(2));
        jpyPairs.total += 1;
      } else if (posNegAll == "all") {
        jpyPairs.profit =
            double.parse((jpyPairs.profit + profit).toStringAsFixed(2));
        jpyPairs.total += 1;
      }
    }
    // NZD PAIRS
    if (symbol.contains("NZD")) {
      if (posNegAll == "positive" && profit >= 0) {
        nzdPairs.profit =
            double.parse((nzdPairs.profit + profit).toStringAsFixed(2));
        nzdPairs.total += 1;
      } else if (posNegAll == "negative" && profit < 0) {
        nzdPairs.profit =
            double.parse((nzdPairs.profit + profit).toStringAsFixed(2));
        nzdPairs.total += 1;
      } else if (posNegAll == "all") {
        nzdPairs.profit =
            double.parse((nzdPairs.profit + profit).toStringAsFixed(2));
        nzdPairs.total += 1;
      }
    }
  });
  final List<StatsDataSymbolType> _symbolProfitList = [
    eurPairs,
    usdPairs,
    gbpPairs,
    chfPairs,
    audPairs,
    cadPairs,
    jpyPairs,
    nzdPairs,
  ];
  return _symbolProfitList;
}
// ================================================

//  HELPER CLASSES ==================================

class TradesDataByTime {
  TradesDataByTime({@required this.date, @required this.profit, this.color});
  final DateTime date;
  final double profit;
  Color color;
}

class StatsDataSymbolType {
  StatsDataSymbolType({
    @required this.symbolType,
    @required this.profit,
    this.total,
  });
  final String symbolType;
  double profit;
  int total;
}
// ================================================
