import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CongestionChart
    extends StatelessWidget {

  final List<int> values;

  const CongestionChart({
    super.key,
    required this.values,
  });

  @override
  Widget build(
      BuildContext context) {

    return SizedBox(
      height: 250,

      child: LineChart(

        LineChartData(

          lineBarsData: [

            LineChartBarData(

              spots:

                  values
                      .asMap()
                      .entries
                      .map(
                        (e) =>
                            FlSpot(
                          e.key
                              .toDouble(),
                          e.value
                              .toDouble(),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}