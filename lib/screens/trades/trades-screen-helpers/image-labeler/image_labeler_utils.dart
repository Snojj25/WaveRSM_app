import 'package:flutter/material.dart';
import 'package:forex_app/models/trade.model.dart';

import 'package:super_tooltip/super_tooltip.dart';

class TradesListView extends StatelessWidget {
  final List<Trade> trades;
  const TradesListView({Key key, @required this.trades}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: ListView.builder(
        itemCount: trades.length,
        itemBuilder: (ctx, idx) => ListTile(
          leading: Text(
            idx.toString(),
            textScaleFactor: 1.2,
            style: TextStyle(color: Colors.white),
          ),
          title: Text(
            trades[idx].symbol,
            textScaleFactor: 1.2,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            trades[idx].entry.toString() + " => " + trades[idx].exit.toString(),
            textScaleFactor: 1.2,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class InnerAddTradesButton extends StatelessWidget {
  const InnerAddTradesButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 50,
      width: 0.9 * width,
      alignment: Alignment.center,
      child: Text(
        "Add trades",
        style: TextStyle(color: Colors.white),
        textScaleFactor: 1.3,
      ),
    );
  }
}

// ! == TRADES ListView ====================================================

class AddTradesExpandedButton extends StatelessWidget {
  final String text;
  final Color color;
  final String side;
  const AddTradesExpandedButton(
      {Key key, @required this.text, @required this.color, @required this.side})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.horizontal(
          left: side == "left" ? Radius.circular(10) : Radius.zero,
          right: side == "right" ? Radius.circular(10) : Radius.zero,
        ),
      ),
      width: 0.45 * width,
      child: Row(
        children: [
          Tooltip(
            message: "This is a tooltip message.",
            child: TextButton(
              onPressed: () {
                print("Pressed");
              },
              child: Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent),
                elevation: MaterialStateProperty.resolveWith((states) => 0),
                fixedSize: MaterialStateProperty.resolveWith(
                    (states) => Size(110, 35)),
              ),
            ),
          ),
          Tooltip(
            message: "This is the tooltip message",
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent),
                elevation: MaterialStateProperty.resolveWith((states) => 0),
              ),
              onPressed: () {
                print("pressed");
                tooltip.show(context);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  "assets/info.jpg",
                  fit: BoxFit.contain,
                  width: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final tooltip = SuperTooltip(
  popupDirection: TooltipDirection.down,
  backgroundColor: Colors.green,
  content: Text(
    "Lorem ipsum dolor sit amet, consetetur sadipscingelitr, "
    "sed diam nonumy eirmod tempor invidunt ut laboreet dolore magna aliquyam erat, "
    "sed diam voluptua. At vero eos et accusam et justoduo dolores et ea rebum. ",
    softWrap: true,
    style: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 15,
      color: Colors.black,
      decoration: TextDecoration.none,
    ),
  ),
);
