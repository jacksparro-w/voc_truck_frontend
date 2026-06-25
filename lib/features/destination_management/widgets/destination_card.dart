import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/destination_model.dart';

class DestinationCard extends StatelessWidget {
  final DestinationModel destination;

  const DestinationCard({
    super.key,
    required this.destination,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
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
                color: AppTheme.accent
                    .withOpacity(0.12),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on,
                color: AppTheme.accent,
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
                    destination.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "${destination.type} • Radius ${destination.radius} m",
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "${destination.latitude}, ${destination.longitude}",
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          color:
                              const Color(0xFF64748B),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
