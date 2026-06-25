import 'package:flutter/material.dart';

import '../../../core/network/api_response_parser.dart';
import '../models/truck_model.dart';
import '../services/truck_management_service.dart';
import '../widgets/truck_card.dart';
import 'assign_driver_screen.dart';
import 'create_truck_screen.dart';

class TrucksScreen extends StatefulWidget {
  const TrucksScreen({
    super.key,
  });

  @override
  State<TrucksScreen> createState() => _TrucksScreenState();
}

class _TrucksScreenState extends State<TrucksScreen> {
  final service = TruckManagementService();

  List<TruckModel> trucks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTrucks();
  }

  Future<void> loadTrucks() async {
    try {
      final response = await service.getTrucks();

      final items = ApiResponseParser.listFrom(
        response.data,
      );

      if (!mounted) return;

      setState(() {
        trucks = items
            .map(
              (e) => TruckModel.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList();
        loading = false;
      });
    } catch (e) {
      debugPrint(
        e.toString(),
      );

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> openCreateTruck() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateTruckScreen(),
      ),
    );

    if (created == true) {
      loadTrucks();
    }
  }

  Future<void> openAssignDriver(
    TruckModel truck,
  ) async {
    final assigned = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AssignDriverScreen(
          truck: truck,
        ),
      ),
    );

    if (assigned == true) {
      loadTrucks();
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trucks",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreateTruck,
        child: const Icon(
          Icons.add,
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : trucks.isEmpty
              ? const Center(
                  child: Text(
                    "No trucks found",
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadTrucks,
                  child: ListView.builder(
                    itemCount: trucks.length,
                    itemBuilder: (_, index) {
                      final truck = trucks[index];

                      return TruckCard(
                        truck: truck,
                        onAssignDriver: () => openAssignDriver(
                          truck,
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
