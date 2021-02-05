import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../models/trade.model.dart';
import '../../trades_screen.dart';
import '../chart_helpers.dart';

// * 1. PROFIT BY MONTH CHART =======================================
// * ================================================================
class ProfitByMonthChart extends StatefulWidget {
  final List<Trade> allTrades;
  final String colorScheme;
  const ProfitByMonthChart({
    Key key,
    @required this.allTrades,
    @required this.colorScheme,
  }) : super(key: key);

  @override
  _ProfitByMonthChartState createState() => _ProfitByMonthChartState();
}

class _ProfitByMonthChartState extends State<ProfitByMonthChart> {
  bool isLoading = true;
  List<TradesDataByTime> allTradesProfit;
  @override
  void initState() {
    allTradesProfit = getAllTradesProfit(allTrades);
    isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return isLoading
        ? CircularProgressIndicator()
        : Container(
            child: SfCartesianChart(
              plotAreaBorderWidth: 1,
              title: ChartTitle(
                text: "PROFIT ANALYSIS",
                textStyle: TextStyle(
                  color: widget.colorScheme == "dark"
                      ? Colors.white
                      : Colors.grey[900],
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 0.035 * height,
                ),
              ),
              legend: Legend(
                title: LegendTitle(text: "Legend 1"),
              ),
              primaryXAxis: DateTimeAxis(
                // intervalType: DateTimeIntervalType.months,
                // interval: 0.5,
                rangePadding: ChartRangePadding.auto,
                labelPosition: ChartDataLabelPosition.outside,
                associatedAxisName: "Date",
                edgeLabelPlacement: EdgeLabelPlacement.none,
                labelStyle: TextStyle(
                  color: widget.colorScheme == "dark"
                      ? Colors.white
                      : Colors.grey[900],
                  fontWeight: FontWeight.w500,
                  fontSize: 0.02 * height,
                ),
              ),
              primaryYAxis: NumericAxis(
                labelPosition: ChartDataLabelPosition.outside,
                associatedAxisName: "Profit",
                edgeLabelPlacement: EdgeLabelPlacement.none,
                labelStyle: TextStyle(
                  color: widget.colorScheme == "dark"
                      ? Colors.white
                      : Colors.grey[900],
                  fontWeight: FontWeight.w500,
                  fontSize: 0.02 * height,
                ),
              ),
              zoomPanBehavior: ZoomPanBehavior(
                enableDoubleTapZooming: true,
                enableSelectionZooming: true,
                enablePanning: true,
                enablePinching: true,
                zoomMode: ZoomMode.x,
                selectionRectBorderColor: Colors.red,
                selectionRectBorderWidth: 5,
                selectionRectColor: widget.colorScheme == "dark"
                    ? Colors.white
                    : Colors.grey[900],
              ),
              enableAxisAnimation: true,
              tooltipBehavior: TooltipBehavior(
                enable: true,
                header: "",
                canShowMarker: false,
                animationDuration: 750,
                color: widget.colorScheme == "dark"
                    ? Colors.blue[900]
                    : Colors.grey[900],
                duration: 5000,
                decimalPlaces: 2,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 0.022 * height,
                ),
              ),
              // Series
              series: <LineSeries<TradesDataByTime, DateTime>>[
                LineSeries<TradesDataByTime, DateTime>(
                  name: "firstChartSeries",
                  dataSource: allTradesProfit,
                  pointColorMapper: (TradesDataByTime trade, _) => trade.color,
                  xValueMapper: (TradesDataByTime trade, _) => trade.date,
                  yValueMapper: (TradesDataByTime trade, _) => trade.profit,
                  yAxisName: "profit",
                  animationDuration: 5000,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    color: Colors.black54,
                    borderWidth: 1,
                    width: 7,
                    height: 7,
                  ),
                )
              ],
            ),
          );
  }
}
// * =================================================================
// * =================================================================
