import 'package:flutter/material.dart';
import 'package:forex_app/screens/settings/app_settings.config.dart';
import 'package:intl/intl.dart';
import 'package:eventify/eventify.dart';

import '../../../../models/trade.model.dart';
import './single_trade_utils.dart';

class SingleTrade extends StatefulWidget {
  final Trade trade;
  const SingleTrade({Key key, @required this.trade}) : super(key: key);

  @override
  _SingleTradeState createState() => _SingleTradeState();
}

class _SingleTradeState extends State<SingleTrade>
    with SingleTickerProviderStateMixin {
  final EventEmitter emitter = new EventEmitter();

  bool editting = false;
  String _colorScheme;

  AnimationController _controller;
  Animation<double> _animation1;

  @override
  void initState() {
    emitter.on("test", null, (ev, context) {
      print("${ev.eventName} - ${ev.eventData}");
      setState(() {
        editting = ev.eventData;
      });
    });

    getColorScheme().then((clrScheme) {
      setState(() {
        _colorScheme = clrScheme;
      });
    });

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Container(
        height: _animation1.value * 370 + 70,
        // margin: EdgeInsets.only(bottom: (1 - _animation1.value) * 440),
        child: !editting
            ? NormalSingleTradeTile(
                trade: widget.trade, emitter: emitter, controller: _controller)
            : EditSingleTradeForm(
                trade: widget.trade,
                emitter: emitter,
                animationController: _controller),
      ),
    );
  }
}

_showTradeDialog(BuildContext context, Trade trade, EventEmitter emitter,
    AnimationController controller) {
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
            height: 330,
            // padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                DialogTitleRow(
                  trade: trade,
                  emitter: emitter,
                  controller: controller,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      TradeTextRow(
                          text1: "Profit: ",
                          text2: trade.profit.toString(),
                          profit: trade.profit),
                      TradeTextRow(
                          text1: "Trade type: ",
                          text2: trade.tradeType.toString()),
                      TradeTextRow(
                          text1: "Entry: ", text2: trade.entry.toString()),
                      TradeTextRow(
                          text1: "Exit: ", text2: trade.exit.toString()),
                      TradeTextRow(
                          text1: "Lot size: ", text2: trade.lotSize.toString()),
                      TradeTextRow(
                          text1: "Date: ",
                          text2:
                              DateFormat("yyyy-MM-dd").format(trade.dateTime)),
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

class NormalSingleTradeTile extends StatelessWidget {
  final Trade trade;
  final EventEmitter emitter;
  final AnimationController controller;
  const NormalSingleTradeTile(
      {Key key,
      @required this.trade,
      @required this.emitter,
      @required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        trade.symbol,
        textScaleFactor: 1.2,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: trade.profit > 0 ? Colors.green[700] : Colors.red,
        ),
      ),
      subtitle: Text(
        trade.entry.toString() + " -> " + trade.exit.toString(),
        textScaleFactor: 1.2,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: trade.profit > 0 ? Colors.green[700] : Colors.red,
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.black87,
        radius: 40,
        child: Text(
          trade.profit.toString(),
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: trade.profit > 0 ? Colors.green : Colors.red,
          ),
        ),
      ),
      trailing: Text(
        DateFormat("yyyy-MM-dd").format(trade.dateTime),
      ),
      onTap: () {
        _showTradeDialog(
          context,
          trade,
          emitter,
          controller,
        );
      },
    );
  }
}

class EditSingleTradeForm extends StatefulWidget {
  final EventEmitter emitter;
  final Trade trade;
  final AnimationController animationController;
  EditSingleTradeForm({
    Key key,
    @required this.trade,
    @required this.emitter,
    @required this.animationController,
  }) : super(key: key);

  @override
  _EditSingletradeTormState createState() => _EditSingletradeTormState();
}

class _EditSingletradeTormState extends State<EditSingleTradeForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _symbolController;
  TextEditingController _profitController;
  TextEditingController _tradeTypeController;
  TextEditingController _entryController;
  TextEditingController _exitController;
  TextEditingController _lotSizeController;

  String _colorScheme;

  @override
  void initState() {
    _symbolController = TextEditingController();
    _profitController = TextEditingController();
    _tradeTypeController = TextEditingController();
    _entryController = TextEditingController();
    _exitController = TextEditingController();
    _lotSizeController = TextEditingController();

    getColorScheme().then((clrScheme) {
      _colorScheme = clrScheme;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _colorScheme == "dark" ? Colors.indigo[900] : Colors.grey,
        ),
        child: Column(
          children: [
            EditTradeRow(
              text: "symbol",
              controller: _symbolController,
              initialValue: widget.trade.symbol,
              isNumeric: false,
              colorScheme: _colorScheme,
            ),
            EditTradeRow(
              text: "profit",
              controller: _profitController,
              initialValue: widget.trade.profit.toString(),
              isNumeric: true,
              colorScheme: _colorScheme,
            ),
            EditTradeRow(
              text: "Trade type",
              controller: _tradeTypeController,
              initialValue: widget.trade.tradeType,
              isNumeric: false,
              colorScheme: _colorScheme,
            ),
            EditTradeRow(
              text: "Entry",
              controller: _entryController,
              initialValue: widget.trade.entry.toString(),
              isNumeric: true,
              colorScheme: _colorScheme,
            ),
            EditTradeRow(
              text: "Exit",
              controller: _exitController,
              initialValue: widget.trade.exit.toString(),
              isNumeric: true,
              colorScheme: _colorScheme,
            ),
            EditTradeRow(
              text: "lot size",
              controller: _lotSizeController,
              initialValue: widget.trade.lotSize.toString(),
              isNumeric: true,
              colorScheme: _colorScheme,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CancelSaveEdtiTradeButton(
                controlers: [
                  _symbolController,
                  _profitController,
                  _tradeTypeController,
                  _entryController,
                  _exitController,
                  _lotSizeController,
                ],
                emitter: widget.emitter,
                trade: widget.trade,
                animationController: widget.animationController,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// =========================================================
