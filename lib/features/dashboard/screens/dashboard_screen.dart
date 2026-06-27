import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/network/api_response_parser.dart';
import '../../../core/storage/secure_storage.dart';
import '../../alerts/screens/alerts_screen.dart';
import '../../cargo_management/screens/cargo_types_screen.dart';
import '../../destination_management/screens/destinations_screen.dart';
import '../../driver_management/screens/drivers_screen.dart';
import '../../truck_management/screens/trucks_screen.dart';
import '../../tracking/screens/live_map_screen.dart';
import '../../trucks/screens/truck_monitoring_screen.dart';
import '../../trips/screens/trip_history_screen.dart';
import '../models/dashboard_summary.dart';
import '../services/dashboard_service.dart';
import '../widgets/summary_card.dart';

class DashboardScreen
    extends StatefulWidget {

  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen>
      createState() =>
          _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  final dashboardService =
      DashboardService();

  DashboardSummary? summary;

  bool loading = true;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    guardAndLoadDashboard();
  }

  Future<void> guardAndLoadDashboard()
      async {

    final role =
        (await SecureStorage.getRole())?.toUpperCase();

    if (!mounted) return;

    if (role == "DRIVER") {
      context.go("/driver-dashboard");
      return;
    }

    await loadDashboard();
  }

  Future<void> loadDashboard()
      async {

    try {

      final response =
          await dashboardService
              .getSummary();

      if (!mounted) return;

      setState(() {
        summary =
            DashboardSummary
                .fromJson(
          ApiResponseParser.mapFrom(
            response.data,
          ),
        );

        errorMessage = null;
        loading = false;
      });

    } catch (e) {

      debugPrint(
        e.toString(),
      );

      if (e is DioException &&
          e.response?.statusCode == 401) {
        await SecureStorage.clear();

        if (!mounted) return;

        context.go("/login");
        return;
      }

      if (!mounted) return;

      setState(() {
        errorMessage =
            "Unable to load dashboard. Please try again.";
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
          "Control Room",
        ),
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : summary == null
              ? Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                            24),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Text(
                          errorMessage ??
                              "No dashboard data available.",
                          textAlign:
                              TextAlign.center,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              loading = true;
                              errorMessage = null;
                            });

                            loadDashboard();
                          },
                          child: const Text(
                            "Retry",
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh:
                      loadDashboard,
                  child: ListView(
                    padding:
                        const EdgeInsets.all(
                            16),
                    children: [
                      _ControlRoomHeader(
                        activeTrips: summary!
                            .activeTrips,
                        alerts: summary!
                            .alerts,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      LayoutBuilder(
                        builder:
                            (context, constraints) {
                          final columns =
                              constraints.maxWidth >
                                      620
                                  ? 4
                                  : 2;

                          return GridView.count(
                            crossAxisCount:
                                columns,
                            crossAxisSpacing:
                                12,
                            mainAxisSpacing:
                                12,
                            childAspectRatio:
                                columns == 4
                                    ? 1.15
                                    : 1.03,
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            children: [
                              SummaryCard(
                                title:
                                    "Total Trucks",
                                value: summary!
                                    .totalTrucks
                                    .toString(),
                                icon: Icons
                                    .local_shipping,
                                color:
                                    AppTheme.primary,
                              ),
                              SummaryCard(
                                title:
                                    "Active Trips",
                                value: summary!
                                    .activeTrips
                                    .toString(),
                                icon: Icons.route,
                                color:
                                    AppTheme.success,
                              ),
                              SummaryCard(
                                title: "Alerts",
                                value: summary!
                                    .alerts
                                    .toString(),
                                icon: Icons
                                    .warning_amber,
                                color:
                                    AppTheme.warning,
                              ),
                              SummaryCard(
                                title:
                                    "Congestion",
                                value: summary!
                                    .congestionEvents
                                    .toString(),
                                icon: Icons.traffic,
                                color:
                                    const Color(
                                        0xFF7C3AED),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Operations",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      _ActionTile(
                        icon: Icons.visibility,
                        title:
                            "Truck Monitoring",
                        subtitle:
                            "Review live vehicle status and cargo movement",
                        onTap: () =>
                            _open(
                          context,
                          const TruckMonitoringScreen(),
                        ),
                      ),
                      _ActionTile(
                        icon: Icons.map,
                        title:
                            "Live Tracking",
                        subtitle:
                            "Open the fleet map and current positions",
                        onTap: () =>
                            _open(
                          context,
                          const LiveMapScreen(),
                        ),
                      ),
                      _ActionTile(
                        icon: Icons.history,
                        title:
                            "Trip History",
                        subtitle:
                            "Review completed and past trips",
                        onTap: () =>
                            _open(
                          context,
                          const TripHistoryScreen(),
                        ),
                      ),
                      _ActionTile(
                        icon: Icons
                            .notifications_active,
                        title: "Alerts",
                        subtitle:
                            "Check route, cargo, and congestion alerts",
                        onTap: () =>
                            _open(
                          context,
                          const AlertsScreen(),
                        ),
                      ),
                      _ActionTile(
                        icon: Icons.people,
                        title:
                            "Driver Management",
                        subtitle:
                            "Create drivers and manage assignments",
                        onTap: () =>
                            _open(
                          context,
                          const DriversScreen(),
                        ),
                      ),
                      _ActionTile(
                        icon: Icons
                            .local_shipping,
                        title:
                            "Truck Management",
                        subtitle:
                            "Add trucks, inspect status, and assign drivers",
                        onTap: () =>
                            _open(
                          context,
                          const TrucksScreen(),
                        ),
                      ),
                      _ActionTile(
                        icon: Icons.place,
                        title:
                            "Destination Management",
                        subtitle:
                            "Maintain delivery points and routes",
                        onTap: () =>
                            _open(
                          context,
                          const DestinationsScreen(),
                        ),
                      ),
                      _ActionTile(
                        icon: Icons.inventory_2,
                        title:
                            "Cargo Type Management",
                        subtitle:
                            "Create cargo types for loaded trips",
                        onTap: () =>
                            _open(
                          context,
                          const CargoTypesScreen(),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void _open(
    BuildContext context,
    Widget screen,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }
}

class _ControlRoomHeader extends StatelessWidget {
  final int activeTrips;
  final int alerts;

  const _ControlRoomHeader({
    required this.activeTrips,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    final attentionText =
        alerts == 0 ? "All clear" : "$alerts alerts need review";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary
                .withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.14),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.radar,
                  color: Colors.white,
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
                      "Fleet command center",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$activeTrips trips active now",
                      style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white
                  .withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  alerts == 0
                      ? Icons.check_circle
                      : Icons.priority_high,
                  color: alerts == 0
                      ? AppTheme.success
                      : AppTheme.warning,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    attentionText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.accent
                      .withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.accent,
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
                          .titleMedium,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
