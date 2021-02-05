import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';

import './all_trades.dart';
import '../../services/ml_vision.service.dart';
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
      drawer:
          AppDrawer(colorScheme: colorScheme, userData: userData, active: 1),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colorScheme == "dark"
                ? [Colors.indigo[900], Colors.grey[900]]
                : [Colors.grey[500], Colors.white],
          ),
        ),
        child: ImageLabeler(),
      ),
    );
  }
}

// ! ==========================================

class ImageLabeler extends StatefulWidget {
  const ImageLabeler({Key key}) : super(key: key);

  @override
  _ImageLabelerState createState() => _ImageLabelerState();
}

class _ImageLabelerState extends State<ImageLabeler> {
  bool isLoading = false;
  final String uid = GlobalConfiguration().getValue("uid");

  File _selectedImage;
  VisionText _visionText;
  List<List<String>> _tradesList = [];
  List<Trade> _trades = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              _selectedImage = await getImageFile().catchError((err) {
                print("error code: 3001");
                print(err);
              });
              setState(() {
                _selectedImage = _selectedImage;
              });
              if (_selectedImage != null) {
                _visionText =
                    await getVisionText(_selectedImage).catchError((err) {
                  print("error code: 3002");
                  print(err);
                });
                _tradesList = getTradeInfo(_visionText);
                try {
                  for (var i = 0; i < _tradesList.length; i++) {
                    if (_tradesList[i].length == 3) {
                      Trade trade = makeTrade(_tradesList[i]);
                      _trades.add(trade);
                    }
                  }
                } catch (err) {
                  print("error code: 3003");
                  print(err);
                }
                setState(() {
                  _trades = _trades;
                  isLoading = false;
                });
              } else {
                setState(() {
                  isLoading = false;
                  _selectedImage = null;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 50,
              width: 500,
              alignment: Alignment.center,
              child: Text(
                "Add trades",
                style: TextStyle(color: Colors.white),
                textScaleFactor: 1.3,
              ),
            ),
          ),
        ),
        isLoading == true
            ? CircularProgressIndicator()
            : _selectedImage != null && _trades != []
                ? Column(
                    children: [
                      Container(
                        height: 250,
                        child: Image.file(
                          _selectedImage,
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 250,
                            child: ListView.builder(
                              itemCount: _trades.length,
                              itemBuilder: (ctx, idx) => ListTile(
                                leading: Text(
                                  idx.toString(),
                                  textScaleFactor: 1.2,
                                  style: TextStyle(color: Colors.white),
                                ),
                                title: Text(
                                  _trades[idx].symbol,
                                  textScaleFactor: 1.2,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  _trades[idx].entry.toString() +
                                      " => " +
                                      _trades[idx].exit.toString(),
                                  textScaleFactor: 1.2,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            right: 15,
                            child: IconButton(
                              icon: Icon(
                                Icons.save,
                                size: 20,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                for (var i = 0; i < _trades.length; i++) {
                                  await DataBaseService()
                                      .addTrade(_trades[i], uid)
                                      .catchError((err) {
                                    print(err);
                                  });
                                }
                                setState(() {
                                  _trades = [];
                                  _selectedImage = null;
                                  isLoading = false;
                                });
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )
                : Expanded(child: AllTrades()),
      ],
    );
  }
}

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
