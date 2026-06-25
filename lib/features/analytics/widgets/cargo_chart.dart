import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CargoChart
    extends StatelessWidget {

  final Map<String, int> data;

  const CargoChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(
      BuildContext context) {

    return SizedBox(
      height: 250,

      child: PieChart(

        PieChartData(

          sections:
              data.entries.map((e) {

            return PieChartSectionData(
              value:
                  e.value.toDouble(),

              title:
                  "${e.key}\n${e.value}",
            );

          }).toList(),
        ),
      ),
    );
  }
}