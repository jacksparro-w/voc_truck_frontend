import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class SummaryCard
    extends StatelessWidget {

  final String title;

  final String value;

  final IconData icon;

  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color = AppTheme.primary,
  });

  @override
  Widget build(
      BuildContext context) {

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                fontSize: 28,
              ),
            ),

            const SizedBox(
              height: 4,
            ),

            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
