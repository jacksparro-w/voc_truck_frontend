import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/truck_model.dart';

class TruckCard extends StatelessWidget {
  final TruckModel truck;
  final VoidCallback onAssignDriver;

  const TruckCard({
    super.key,
    required this.truck,
    required this.onAssignDriver,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final assignedDriver =
        truck.driverName == null || truck.driverName!.isEmpty
            ? "Not assigned"
            : truck.driverName!;

    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppTheme.primary
                    .withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_shipping,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    truck.truckNumber,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "${truck.truckType} • ${truck.status}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Driver: $assignedDriver",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              icon: const Icon(
                Icons.person_add_alt_1,
              ),
              tooltip: "Assign Driver",
              onPressed: onAssignDriver,
            ),
          ],
        ),
      ),
    );
  }
}
