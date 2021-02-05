import 'package:flutter/cupertino.dart';

class Trade {
  final String symbol;
  final String tradeType;
  final double lotSize;
  final double entry;
  final double exit;
  final DateTime dateTime;
  final double profit;

  Trade({
    @required this.symbol,
    @required this.tradeType,
    @required this.lotSize,
    @required this.entry,
    @required this.exit,
    @required this.dateTime,
    @required this.profit,
  });
}

class TradeStats {
  final double profit;
  final int totalTrades;
  final int positiveTrades;
  final int negativeTrades;
  final double positiveTotal;
  final double negativeTotal;
  final String month;

  TradeStats({
    @required this.profit,
    @required this.totalTrades,
    @required this.positiveTrades,
    @required this.negativeTrades,
    @required this.positiveTotal,
    @required this.negativeTotal,
    this.month,
  });
}
