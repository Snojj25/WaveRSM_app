import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../trades_screen.dart';
import 'chart_helpers.dart';

class ColumnSymbolChart extends StatelessWidget {
  final String posNegAll;
  final String colorScheme;
  const ColumnSymbolChart(
      {Key key, @required this.posNegAll, @required this.colorScheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      child: SfCartesianChart(
        title: ChartTitle(
          text: "<- SYMBOL ANALYSIS",
          textStyle: TextStyle(
            color: colorScheme == "dark" ? Colors.white : Colors.grey[900],
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            fontSize: 0.035 * height,
          ),
        ),
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(
            color: colorScheme == "dark" ? Colors.white : Colors.grey[900],
            fontWeight: FontWeight.w500,
            fontSize: 0.02 * height,
          ),
        ),
        primaryYAxis: NumericAxis(
          labelStyle: TextStyle(
            color: colorScheme == "dark" ? Colors.white : Colors.grey[900],
            fontWeight: FontWeight.w500,
            fontSize: 0.02 * height,
          ),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          header: "",
          canShowMarker: false,
          animationDuration: 750,
          color: colorScheme == "dark" ? Colors.blue[900] : Colors.grey[900],
          duration: 5000,
          decimalPlaces: 2,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 0.022 * height,
          ),
        ),
        series: <ColumnSeries<StatsDataSymbolType, String>>[
          ColumnSeries<StatsDataSymbolType, String>(
            // Bind data source
            dataSource: getDataSourceSymbolProfit(allTrades, posNegAll),
            xValueMapper: (StatsDataSymbolType statsDataSymbol, _) =>
                statsDataSymbol.symbolType,
            yValueMapper: (StatsDataSymbolType statsDataSymbol, _) =>
                statsDataSymbol.profit,
            pointColorMapper: (StatsDataSymbolType statsDataSymbol, _) =>
                statsDataSymbol.profit >= 0 ? Colors.green : Colors.red,
            selectionBehavior: SelectionBehavior(
              enable: false,
            ),
            animationDuration: 3000,
          ),
        ],
      ),
    );
  }
}
