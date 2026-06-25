import 'package:flutter/material.dart';

import '../../../core/network/api_response_parser.dart';
import '../models/active_trip_model.dart';
import '../services/trip_service.dart';

class ActiveTripScreen extends StatefulWidget {
  const ActiveTripScreen({
    super.key,
  });

  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> {
  final service = TripService();

  ActiveTripModel? activeTrip;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadActiveTrip();
  }

  Future<void> loadActiveTrip() async {
    try {
      final response = await service.getActiveTrip();
      final data = ApiResponseParser.mapFrom(
        response.data,
      );
      final tripId = data["id"] ?? data["_id"];

      if (!mounted) return;

      setState(() {
        activeTrip = tripId == null ? null : ActiveTripModel.fromJson(data);
        loading = false;
      });
    } catch (e) {
      debugPrint(
        e.toString(),
      );

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final trip = activeTrip;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Active Trip",
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : trip == null
              ? const Center(
                  child: Text(
                    "No active trip",
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  children: [
                    _InfoTile(
                      title: "Truck Number",
                      value: trip.truckNumber,
                    ),
                    _InfoTile(
                      title: "Destination",
                      value: trip.destination,
                    ),
                    _InfoTile(
                      title: "Cargo Type",
                      value: trip.cargoType,
                    ),
                    _InfoTile(
                      title: "Cargo Status",
                      value: trip.cargoStatus,
                    ),
                    _InfoTile(
                      title: "Trip Status",
                      value: trip.tripStatus,
                    ),
                  ],
                ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({
    required this.title,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      child: ListTile(
        title: Text(
          title,
        ),
        subtitle: Text(
          value.isEmpty ? "N/A" : value,
        ),
      ),
    );
  }
}
