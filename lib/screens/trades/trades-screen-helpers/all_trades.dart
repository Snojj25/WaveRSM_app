import 'package:flutter/material.dart';
import 'package:forex_app/models/trade.model.dart';
import 'package:intl/intl.dart';

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
      itemBuilder: (ctx, idx) => ListTile(
        title: Text(
          widget.allTrades[idx].symbol,
          textScaleFactor: 1.2,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.allTrades[idx].profit > 0
                ? Colors.green[700]
                : Colors.red,
          ),
        ),
        subtitle: Text(
          widget.allTrades[idx].entry.toString() +
              " -> " +
              widget.allTrades[idx].exit.toString(),
          textScaleFactor: 1.2,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.allTrades[idx].profit > 0
                ? Colors.green[700]
                : Colors.red,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.black87,
          radius: 40,
          child: Text(
            widget.allTrades[idx].profit.toString(),
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  widget.allTrades[idx].profit > 0 ? Colors.green : Colors.red,
            ),
          ),
        ),
        trailing: Text(
          DateFormat("yyyy-MM-dd").format(widget.allTrades[idx].dateTime),
        ),
        onTap: () {
          _showTradeDialog(ctx, widget.allTrades[idx]);
        },
      ),
    );
  }

  _showTradeDialog(BuildContext context, Trade trade) {
    showGeneralDialog(
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Dialog(
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Container(
              height: 200,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          trade.symbol,
                          style: TextStyle(
                              color:
                                  trade.profit > 0 ? Colors.green : Colors.red),
                          textScaleFactor: 1.3,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Trade type: " + trade.tradeType,
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 1.3,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Entry: " + trade.entry.toString(),
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 1.3,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Exit: " + trade.exit.toString(),
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 1.3,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Profit: " + trade.profit.toString(),
                              style: TextStyle(
                                  color: trade.profit > 0
                                      ? Colors.green
                                      : Colors.red),
                              textScaleFactor: 1.3,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Lot size: " + trade.lotSize.toString(),
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 1.3,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Date: " +
                                  DateFormat("yyyy-MM-dd")
                                      .format(trade.dateTime),
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 1.3,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 400),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return null;
      },
    );
  }
}
