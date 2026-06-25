import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/tracking/services/location_service.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocationService.initializeBackgroundTracking();
  await LocationService.resumeActiveTracking();

  runApp(const ProviderScope(child: VocTruckTrackingApp()));
}

class VocTruckTrackingApp extends StatelessWidget {
  const VocTruckTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      routerConfig: appRouter,
    );
  }
}
