import 'package:flutter/material.dart';

import '../../../core/network/api_response_parser.dart';
import '../models/alert_model.dart';
import '../services/alert_service.dart';
import '../widgets/alert_card.dart';

class AlertsScreen
    extends StatefulWidget {

  const AlertsScreen({
    super.key,
  });

  @override
  State<AlertsScreen>
      createState() =>
          _AlertsScreenState();
}

class _AlertsScreenState
    extends State<AlertsScreen> {

  final alertService =
      AlertService();

  List<AlertModel> alerts =
      [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadAlerts();
  }

  Future<void> loadAlerts()
      async {

    try {

      final response =
          await alertService
              .getAlerts();

      alerts =
          ApiResponseParser
              .listFrom(
                response.data,
                keys: const [
                  "data",
                  "alerts",
                  "items",
                  "results",
                ],
              )
              .map(
                (e) =>
                    AlertModel
                        .fromJson(
                  Map<String, dynamic>
                      .from(e),
                ),
              )
              .toList();

      setState(() {
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
          "Alerts",
        ),
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : ListView.builder(

              itemCount:
                  alerts.length,

              itemBuilder:
                  (context, index) {

                final alert =
                    alerts[index];

                return AlertCard(
                  title:
                      alert.title,

                  message:
                      alert.message,

                  type:
                      alert.type,

                  severity:
                      alert.severity,

                  isResolved:
                      alert.isResolved,
                );
              },
            ),
    );
  }
}
