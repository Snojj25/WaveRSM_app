import 'package:flutter/material.dart';
import 'package:forex_app/screens/trades/trades_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../chart_helpers.dart';

class CircularSymbolChart extends StatelessWidget {
  final String posNegAll;
  final String colorScheme;
  const CircularSymbolChart(
      {Key key, @required this.posNegAll, @required this.colorScheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      child: SfCircularChart(
        margin: const EdgeInsets.all(0.0),
        borderColor: colorScheme == "dark" ? Colors.black : Colors.white70,
        borderWidth: 1,
        enableMultiSelection: true,
        title: posNegAll == "all"
            ? ChartTitle(
                text: "<- SYMBOL ANALYSIS ->",
                textStyle: TextStyle(
                  color:
                      colorScheme == "dark" ? Colors.white : Colors.grey[900],
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 0.035 * height,
                ),
              )
            : null,
        legend: Legend(
          alignment: ChartAlignment.center,
          padding: 20,
          isVisible: true,
          position: LegendPosition.top,
          title: LegendTitle(
            text: posNegAll == "all"
                ? "SYMBOLS"
                : posNegAll == "positive"
                    ? "POSITIVE SYMBOLS"
                    : "NEGATIVE SYMBOLS",
            textStyle: TextStyle(
              color: colorScheme == "dark" ? Colors.red : Colors.indigo[900],
              fontSize: 0.03 * height,
              fontWeight: FontWeight.bold,
            ),
          ),
          textStyle: TextStyle(
            color: colorScheme == "dark" ? Colors.white : Colors.grey[900],
            fontWeight: FontWeight.w500,
            fontSize: 0.022 * height,
          ),

          toggleSeriesVisibility: true,
          iconBorderColor: Colors.black54,
          iconBorderWidth: 1,
          borderColor: colorScheme == "dark" ? Colors.black : Colors.white,
          borderWidth: 1,
          orientation: LegendItemOrientation.horizontal,
          overflowMode: LegendItemOverflowMode.wrap,
          backgroundColor: colorScheme == "dark"
              ? Colors.transparent
              : Colors.grey[900].withOpacity(0.1),
          // alignment: ChartAlignment.center,
        ),
        series: <PieSeries<StatsDataSymbolType, String>>[
          PieSeries<StatsDataSymbolType, String>(
            // Bind data source
            dataSource: getDataSourceSymbolProfit(allTrades, posNegAll),
            xValueMapper: (StatsDataSymbolType statsDataSymbol, _) =>
                statsDataSymbol.symbolType,
            yValueMapper: (StatsDataSymbolType statsDataSymbol, _) =>
                statsDataSymbol.profit,
            enableSmartLabels: true,
            selectionBehavior: SelectionBehavior(
              enable: true,
            ),
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              connectorLineSettings: ConnectorLineSettings(
                color: posNegAll == "all"
                    ? Colors.blue
                    : posNegAll == "positive" ? Colors.green : Colors.red,
                length: "5%",
                type: ConnectorType.curve,
                width: 3,
              ),
              color: posNegAll == "all"
                  ? Colors.blue[800]
                  : posNegAll == "positive" ? Colors.green[800] : Colors.red,
              useSeriesColor: true,
              textStyle: TextStyle(
                color: posNegAll == "all"
                    ? Colors.white
                    : posNegAll == "positive" ? Colors.white : Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 15,
                shadows: [
                  Shadow(
                    color: posNegAll == "all"
                        ? Colors.black
                        : posNegAll == "positive" ? Colors.black : Colors.black,
                    blurRadius: 2,
                    offset: Offset.fromDirection(7, 5),
                  ),
                ],
              ),
              showZeroValue: false,
            ),

            animationDuration: 2000,
          ),
        ],
      ),
    );
  }
}

// & DOUBLE SIMBOL CHART
class DoubleSimbolPieChart extends StatelessWidget {
  final String colorScheme;
  const DoubleSimbolPieChart({Key key, @required this.colorScheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "POS AND NEG ANALYSIS ->",
                    style: TextStyle(
                      color: colorScheme == "dark"
                          ? Colors.white
                          : Colors.grey[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 0.032 * height,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Container(
              height: 0.6 * height,
              child: CircularSymbolChart(
                  posNegAll: "positive", colorScheme: colorScheme),
            ),
            Container(
              height: 0.6 * height,
              child: CircularSymbolChart(
                  posNegAll: "negative", colorScheme: colorScheme),
            ),
          ],
        ),
      ),
    );
  }
}
