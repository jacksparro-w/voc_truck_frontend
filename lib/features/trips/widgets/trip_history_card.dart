import 'package:flutter/material.dart';

import '../models/trip_history_model.dart';

class TripHistoryCard extends StatelessWidget {
  final TripHistoryModel trip;

  const TripHistoryCard({
    super.key,
    required this.trip,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.route,
        ),
        title: Text(
          trip.destination,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cargo: ${trip.cargo}",
            ),
            Text(
              "Status: ${trip.status}",
            ),
            if (trip.startedAt.isNotEmpty)
              Text(
                "Started: ${trip.startedAt}",
              ),
            if (trip.completedAt.isNotEmpty)
              Text(
                "Completed: ${trip.completedAt}",
              ),
          ],
        ),
      ),
    );
  }
}
