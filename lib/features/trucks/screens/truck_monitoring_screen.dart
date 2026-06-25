import 'package:flutter/material.dart';

import '../../../core/network/api_response_parser.dart';
import '../models/truck_monitor.dart';
import '../services/truck_service.dart';
import '../widgets/truck_card.dart';

class TruckMonitoringScreen
    extends StatefulWidget {

  const TruckMonitoringScreen({
    super.key,
  });

  @override
  State<TruckMonitoringScreen>
      createState() =>
          _TruckMonitoringScreenState();
}

class _TruckMonitoringScreenState
    extends State<
        TruckMonitoringScreen> {

  final truckService =
      TruckService();

  List<TruckMonitor> trucks =
      [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadTrucks();
  }

  Future<void> loadTrucks()
      async {

    try {

      final response =
          await truckService
              .getTruckMonitoring();

      trucks =
          ApiResponseParser
              .listFrom(
                response.data,
                keys: const [
                  "data",
                  "trucks",
                  "items",
                  "results",
                ],
              )
              .map(
                (e) =>
                    TruckMonitor
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
          "Truck Monitoring",
        ),
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : ListView.builder(

              itemCount:
                  trucks.length,

              itemBuilder:
                  (context, index) {

                final truck =
                    trucks[index];

                return TruckCard(
                  truckNumber:
                      truck
                          .truckNumber,

                  driverName:
                      truck
                          .driverName,

                  status:
                      truck.status,

                  cargo:
                      truck.cargo,

                  destination:
                      truck
                          .destination,

                  tripStatus:
                      truck
                          .tripStatus,
                );
              },
            ),
    );
  }
}
