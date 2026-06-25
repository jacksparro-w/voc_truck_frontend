import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class TripInfoCard
    extends StatelessWidget {

  final String title;

  final String value;

  final IconData icon;

  const TripInfoCard({
    super.key,
    required this.title,
    required this.value,
    this.icon = Icons.info_outline,
  });

  @override
  Widget build(
      BuildContext context) {

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppTheme.primary
                    .withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.primary,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          color:
                              const Color(0xFF65748B),
                          fontSize: 13,
                        ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    value,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
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
