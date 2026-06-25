import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class TruckCard
    extends StatelessWidget {

  final String truckNumber;

  final String driverName;

  final String status;

  final String cargo;

  final String destination;

  final String tripStatus;

  const TruckCard({
    super.key,
    required this.truckNumber,
    required this.driverName,
    required this.status,
    required this.cargo,
    required this.destination,
    required this.tripStatus,
  });

  Color getStatusColor() {

    switch (status) {

      case "IN_TRANSIT":
        return AppTheme.success;

      case "MAINTENANCE":
        return AppTheme.warning;

      case "OFFLINE":
        return const Color(0xFFDC2626);

      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(
      BuildContext context) {

    final statusColor =
        getStatusColor();

    return Card(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: statusColor
                        .withOpacity(0.12),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_shipping,
                    color: statusColor,
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
                        truckNumber,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Driver: $driverName",
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Chip(
                  visualDensity:
                      VisualDensity.compact,
                  backgroundColor:
                      statusColor,
                  label: Text(
                    status,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 14,
            ),

            _InfoRow(
              icon: Icons.inventory_2,
              label: "Cargo",
              value: cargo,
            ),
            const SizedBox(
              height: 8,
            ),
            _InfoRow(
              icon: Icons.place,
              label: "Destination",
              value: destination,
            ),
            const SizedBox(
              height: 8,
            ),
            _InfoRow(
              icon: Icons.route,
              label: "Trip",
              value: tripStatus,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF64748B),
          size: 18,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          "$label: ",
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  fontWeight: FontWeight.w700,
              ),
          ),
        ),
      ],
    );
  }
}
