import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ViolationChart
    extends StatelessWidget {

  final List<int> values;

  const ViolationChart({
    super.key,
    required this.values,
  });

  @override
  Widget build(
      BuildContext context) {

    return SizedBox(
      height: 250,

      child: BarChart(

        BarChartData(

          barGroups:

              values
                  .asMap()
                  .entries
                  .map((e) {

            return BarChartGroupData(

              x: e.key,

              barRods: [

                BarChartRodData(
                  toY:
                      e.value
                          .toDouble(),
                )
              ],
            );

          }).toList(),
        ),
      ),
    );
  }
}