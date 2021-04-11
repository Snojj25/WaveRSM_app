import 'package:flutter/material.dart';
import 'package:forex_app/models/trade.model.dart';
import 'package:forex_app/screens/trades/trades-screen-helpers/single-trade/single_trade.dart';

// import '../../services/database.service.dart';

class AllTradesList extends StatefulWidget {
  final List<Trade> allTrades;
  const AllTradesList({Key key, @required this.allTrades}) : super(key: key);

  @override
  _AllTradesListState createState() => _AllTradesListState();
}

class _AllTradesListState extends State<AllTradesList> {
  @override
  Widget build(BuildContext context) {
    // final trades = Provider.of<List<Trade>>(context);
    return ListView.builder(
      itemCount: widget.allTrades.length,
      itemBuilder: (ctx, idx) => SingleTrade(trade: widget.allTrades[idx]),
    );
  }
}
