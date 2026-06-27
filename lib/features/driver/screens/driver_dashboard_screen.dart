import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/network/api_response_parser.dart';
import '../../../core/storage/secure_storage.dart';
import '../models/active_trip.dart';
import '../widgets/trip_info_card.dart';
import '../../tracking/services/location_service.dart';
import '../../trips/screens/active_trip_screen.dart';
import '../../trips/screens/start_trip_screen.dart';
import '../../trips/services/trip_service.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  final tripService = TripService();

  ActiveTrip? activeTrip;

  bool loading = true;

  bool endingTrip = false;

  String driverName = "Driver";

  @override
  void initState() {
    super.initState();

    guardAndLoadTrip();
  }

  Future<void> guardAndLoadTrip() async {
    final role = (await SecureStorage.getRole())?.toUpperCase();
    final name = await SecureStorage.getName();

    if (!mounted) return;

    if (role != "DRIVER") {
      context.go(
        role == "ADMIN" || role == "SUPERVISOR" ? "/dashboard" : "/login",
      );
      return;
    }

    setState(() {
      driverName = name == null || name.isEmpty ? "Driver" : name;
    });

    await loadTrip();
  }

  Future<void> loadTrip() async {
    try {
      final response = await tripService.getActiveTrip();

      if (!mounted) return;

      final data = ApiResponseParser.mapFrom(response.data);
      final tripId = data["id"] ?? data["_id"];

      setState(() {
        activeTrip = tripId == null ? null : ActiveTrip.fromJson(data);

        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() {
        activeTrip = null;
        loading = false;
      });
    }
  }

  Future<void> logout() async {
    await LocationService.stopTracking();
    await SecureStorage.clear();

    if (!mounted) return;

    context.go("/login");
  }

  Future<void> endTrip() async {
    final trip = activeTrip;

    if (trip == null) return;

    setState(() {
      endingTrip = true;
    });

    try {
      await tripService.endTrip(trip.tripId);

      await LocationService.stopTracking();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Trip Ended")));

      await loadTrip();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (!mounted) return;

    setState(() {
      endingTrip = false;
    });
  }

  Future<void> openStartTrip() async {
    final started = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const StartTripScreen()),
    );

    if (started == true) {
      loadTrip();
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = activeTrip;
    final hasActiveTrip = trip != null;
    final gpsStatus = hasActiveTrip ? "Online" : "Standby";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Dashboard"),
        actions: [
          IconButton(
            tooltip: "Logout",
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  _DriverHero(
                    driverName: driverName,
                    hasActiveTrip:
                        hasActiveTrip,
                    gpsStatus: gpsStatus,
                  ),

                  const SizedBox(height: 12),

                  TripInfoCard(
                    title: "My Assigned Truck",
                    value: trip?.truckNumber.isNotEmpty == true
                        ? trip!.truckNumber
                        : "No active truck",
                    icon: Icons.local_shipping,
                  ),
                  const SizedBox(height: 10),

                  TripInfoCard(
                    title: "Current Destination",
                    value: trip?.destination.isNotEmpty == true
                        ? trip!.destination
                        : "No active destination",
                    icon: Icons.place,
                  ),
                  const SizedBox(height: 10),

                  TripInfoCard(
                    title: "Cargo",
                    value: trip?.cargoType.isNotEmpty == true
                        ? trip!.cargoType
                        : "N/A",
                    icon: Icons.inventory_2,
                  ),
                  const SizedBox(height: 10),

                  TripInfoCard(
                    title: "Cargo Status",
                    value: trip?.cargoStatus.isNotEmpty == true
                        ? trip!.cargoStatus
                        : "N/A",
                    icon: Icons.verified_outlined,
                  ),
                  const SizedBox(height: 10),

                  TripInfoCard(
                    title: "Trip Status",
                    value: trip?.tripStatus.isNotEmpty == true
                        ? trip!.tripStatus
                        : "INACTIVE",
                    icon: Icons.route,
                  ),
                  const SizedBox(height: 10),

                  TripInfoCard(
                    title: "GPS",
                    value: gpsStatus,
                    icon: Icons.gps_fixed,
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: hasActiveTrip ? null : openStartTrip,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Start Trip"),
                  ),

                  ElevatedButton.icon(
                    onPressed: endingTrip || !hasActiveTrip ? null : endTrip,
                    icon: endingTrip
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.stop),
                    label: const Text("End Trip"),
                  ),

                  OutlinedButton.icon(
                    onPressed: hasActiveTrip
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ActiveTripScreen(),
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.route),
                    label: const Text("Current Trip"),
                  ),

                  OutlinedButton.icon(
                    onPressed: logout,
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                  ),
                ],
              ),
            ),
    );
  }
}

class _DriverHero extends StatelessWidget {
  final String driverName;
  final bool hasActiveTrip;
  final String gpsStatus;

  const _DriverHero({
    required this.driverName,
    required this.hasActiveTrip,
    required this.gpsStatus,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor =
        hasActiveTrip ? AppTheme.success : AppTheme.warning;
    final statusText =
        hasActiveTrip ? "Trip in progress" : "Ready for assignment";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.14),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome back",
                      style: TextStyle(
                        color: Color(0xFFCBD5E1),
                      ),
                    ),
                    Text(
                      driverName,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeroChip(
                  icon: Icons.route,
                  label: statusText,
                  color: statusColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeroChip(
                  icon: Icons.gps_fixed,
                  label: "GPS $gpsStatus",
                  color: hasActiveTrip
                      ? AppTheme.success
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _HeroChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
