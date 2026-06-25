import 'package:flutter/material.dart';

import '../services/truck_management_service.dart';

class CreateTruckScreen extends StatefulWidget {
  const CreateTruckScreen({
    super.key,
  });

  @override
  State<CreateTruckScreen> createState() => _CreateTruckScreenState();
}

class _CreateTruckScreenState extends State<CreateTruckScreen> {
  final service = TruckManagementService();

  final truckNumberController = TextEditingController();
  final truckTypeController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    truckNumberController.dispose();
    truckTypeController.dispose();
    super.dispose();
  }

  Future<void> createTruck() async {
    setState(() {
      loading = true;
    });

    try {
      await service.createTruck({
        "truckNumber": truckNumberController.text.trim(),
        "truckType": truckTypeController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Truck Created",
          ),
        ),
      );

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Truck",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          20,
        ),
        child: Column(
          children: [
            TextField(
              controller: truckNumberController,
              decoration: const InputDecoration(
                labelText: "Truck Number",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: truckTypeController,
              decoration: const InputDecoration(
                labelText: "Truck Type",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: loading ? null : createTruck,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Create Truck",
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
