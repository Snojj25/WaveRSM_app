import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/database.service.dart';
import '../../services/ml_vision.service.dart';

class AllTrades extends StatefulWidget {
  const AllTrades({Key key}) : super(key: key);

  @override
  _AllTradesState createState() => _AllTradesState();
}

class _AllTradesState extends State<AllTrades> {
  @override
  Widget build(BuildContext context) {
    // final trades = Provider.of<List<Trade>>(context);
    return StreamBuilder(
      stream: DataBaseServce().trades,
      builder: (BuildContext ctx, AsyncSnapshot<List<Trade>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.data.length == 0) {
          return Center(
            child: Text(
              "Add trades",
              textScaleFactor: 1.5,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (ctx, idx) => ListTile(
            title: Text(
              snapshot.data[idx].symbol,
              textScaleFactor: 1.2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    snapshot.data[idx].profit > 0 ? Colors.green : Colors.red,
              ),
            ),
            subtitle: Text(
              snapshot.data[idx].entry.toString() +
                  " -> " +
                  snapshot.data[idx].exit.toString(),
              textScaleFactor: 1.2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    snapshot.data[idx].profit > 0 ? Colors.green : Colors.red,
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.black87,
              foregroundColor: Colors.black,
              radius: 40,
              child: Text(
                snapshot.data[idx].profit.toString(),
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      snapshot.data[idx].profit > 0 ? Colors.green : Colors.red,
                ),
              ),
            ),
            onTap: () {
              _showTradeDialog(ctx, snapshot.data[idx]);
            },
          ),
        );
      },
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
