import 'package:flutter/material.dart';

import '../services/analytics_service.dart';

import '../widgets/cargo_chart.dart';
import '../widgets/violation_chart.dart';
import '../widgets/congestion_chart.dart';

class AnalyticsScreen
    extends StatefulWidget {

  const AnalyticsScreen({
    super.key,
  });

  @override
  State<AnalyticsScreen>
      createState() =>
          _AnalyticsScreenState();
}

class _AnalyticsScreenState
    extends State<
        AnalyticsScreen> {

  final service =
      AnalyticsService();

  Map<String, int>
      cargoData = {};

  List<int>
      violationData = [];

  List<int>
      congestionData = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadAnalytics();
  }

  Future<void> loadAnalytics()
      async {

    try {

      final cargo =
          await service
              .getCargoAnalytics();

      final violation =
          await service
              .getViolationAnalytics();

      final congestion =
          await service
              .getCongestionAnalytics();

      setState(() {

        cargoData =
            Map<String, int>.from(
          cargo.data,
        );

        violationData =
            List<int>.from(
          violation.data,
        );

        congestionData =
            List<int>.from(
          congestion.data,
        );

        loading = false;
      });

    } catch (e) {

      debugPrint(
        e.toString(),
      );

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
          "Analytics",
        ),
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : SingleChildScrollView(

              padding:
                  const EdgeInsets.all(
                      16),

              child: Column(

                children: [

                  const Text(
                    "Cargo Analytics",
                    style:
                        TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  CargoChart(
                    data:
                        cargoData,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    "Route Violations",
                    style:
                        TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  ViolationChart(
                    values:
                        violationData,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    "Congestion",
                    style:
                        TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  CongestionChart(
                    values:
                        congestionData,
                  ),
                ],
              ),
            ),
    );
  }
}