import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class AlertCard
    extends StatelessWidget {

  final String title;

  final String message;

  final String type;

  final String severity;

  final bool isResolved;

  const AlertCard({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    required this.severity,
    required this.isResolved,
  });

  Color severityColor() {

    switch (severity) {

      case "LOW":
        return AppTheme.success;

      case "MEDIUM":
        return AppTheme.warning;

      case "HIGH":
        return AppTheme.accent;

      case "CRITICAL":
        return const Color(0xFFDC2626);

      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(
      BuildContext context) {

    final color =
        severityColor();

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
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_active,
                    color: color,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                ),
                Chip(
                  backgroundColor:
                      color,
                  label: Text(
                    severity,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            Text(message),

            const SizedBox(
              height: 12,
            ),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  visualDensity:
                      VisualDensity.compact,
                  label: Text("Type: $type"),
                ),
                Chip(
                  visualDensity:
                      VisualDensity.compact,
                  label: Text(
                    isResolved
                        ? "Resolved"
                        : "Open",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
