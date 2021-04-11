import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import '../../../../models/trade.model.dart';
import '../../../../services/database.service.dart';
import '../../../../shared/errors.dart';
import '../../../../services/ml_vision.service.dart';
import '../../trades_screen.dart';
import './image_labeler_utils.dart';

class TradeImageLabeler extends StatefulWidget {
  const TradeImageLabeler({Key key}) : super(key: key);

  @override
  _TradeImageLabelerState createState() => _TradeImageLabelerState();
}

class _TradeImageLabelerState extends State<TradeImageLabeler>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  bool isButtonOpen = false;

  File _selectedImage;
  VisionText _visionText;
  List<List<String>> _tradesList = [];
  List<Trade> _trades = [];

  AnimationController _controller;
  Animation<double> _animation1;

  final String uid = GlobalConfiguration().getValue("uid");

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _animation1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ),
    );
    _controller.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                    ),
                    onPressed: () async {
                      // setState(() {
                      //   isLoading = true;
                      // });
                      // makeTradesFromImage();
                      // setState(() {
                      //   isLoading = false;
                      // });

                      if (!isButtonOpen) {
                        _controller.forward().catchError((err) {
                          print(err);
                        });
                      } else {
                        _controller.reverse();
                      }
                      isButtonOpen = !isButtonOpen;
                    },
                    child: InnerAddTradesButton()),
              ),
              AnimatedBuilder(
                animation: _animation1,
                builder: (context, child) => Container(
                  height: _animation1.value * 50,
                  child: child,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AddTradesExpandedButton(
                        text: "MANUAL", color: Colors.blue, side: "left"),
                    AddTradesExpandedButton(
                        text: "MT4", color: Colors.grey[700], side: "right"),
                  ],
                ),
              ),
            ],
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
                          // ==============================
                          TradesListView(trades: _trades),
                          // ==============================
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
                          ),
                          // ==============================
                        ],
                      )
                    ],
                  )
                : Expanded(child: AllTrades()),
      ],
    );
  }

  makeTradesFromImage() async {
    _selectedImage = await getImageFile().catchError((err) {
      showErrorDialog(context, err, "dark");
    });
    setState(() {
      _selectedImage = _selectedImage;
    });
    if (_selectedImage != null) {
      _visionText = await getVisionText(_selectedImage).catchError((err) {
        showErrorDialog(context, err, "dark");
        setState(() {
          isLoading = false;
        });
        return null;
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
        showErrorDialog(context, err, "dark");
        setState(() {
          isLoading = false;
        });
        return null;
      }
      setState(() {
        _trades = _trades;
      });
    } else {
      setState(() {
        isLoading = false;
        _selectedImage = null;
      });
    }
  }
}
