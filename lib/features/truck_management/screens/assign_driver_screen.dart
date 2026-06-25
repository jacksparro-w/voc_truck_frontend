import 'package:flutter/material.dart';

import '../../../core/network/api_response_parser.dart';
import '../models/driver_dropdown_model.dart';
import '../models/truck_model.dart';
import '../services/truck_management_service.dart';

class AssignDriverScreen extends StatefulWidget {
  final TruckModel truck;

  const AssignDriverScreen({super.key, required this.truck});

  @override
  State<AssignDriverScreen> createState() => _AssignDriverScreenState();
}

class _AssignDriverScreenState extends State<AssignDriverScreen> {
  final service = TruckManagementService();

  List<DriverDropdownModel> drivers = [];
  String? selectedDriverId;
  bool loading = true;
  bool assigning = false;

  @override
  void initState() {
    super.initState();
    loadDrivers();
  }

  Future<void> loadDrivers() async {
    try {
      final response = await service.getDrivers();

      final items = ApiResponseParser.listFrom(
        response.data,
        keys: const ["data", "drivers", "items", "results"],
      );

      if (!mounted) return;

      setState(() {
        drivers = items
            .map(
              (e) => DriverDropdownModel.fromJson(Map<String, dynamic>.from(e)),
            )
            .where((driver) => driver.id.isNotEmpty)
            .toList();
        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> assignDriver() async {
    final driverId = selectedDriverId;

    if (driverId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a driver")));
      return;
    }

    setState(() {
      assigning = true;
    });

    try {
      await service.assignDriver(truckId: widget.truck.id, driverId: driverId);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Driver Assigned")));

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (!mounted) return;

    setState(() {
      assigning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assign Driver")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.truck.truckNumber,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    initialValue: selectedDriverId,
                    decoration: const InputDecoration(labelText: "Driver"),
                    items: drivers
                        .map(
                          (driver) => DropdownMenuItem(
                            value: driver.id,
                            child: Text(driver.name),
                          ),
                        )
                        .toList(),
                    onChanged: assigning
                        ? null
                        : (value) {
                            setState(() {
                              selectedDriverId = value;
                            });
                          },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: assigning ? null : assignDriver,
                    child: assigning
                        ? const CircularProgressIndicator()
                        : const Text("Assign Driver"),
                  ),
                ],
              ),
            ),
    );
  }
}
