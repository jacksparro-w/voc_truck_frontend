import 'package:flutter/material.dart';

import '../services/destination_service.dart';

class CreateDestinationScreen extends StatefulWidget {
  const CreateDestinationScreen({super.key});

  @override
  State<CreateDestinationScreen> createState() =>
      _CreateDestinationScreenState();
}

class _CreateDestinationScreenState extends State<CreateDestinationScreen> {
  final service = DestinationService();

  final nameController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final radiusController = TextEditingController();

  String type = "BERTH";
  bool loading = false;

  @override
  void dispose() {
    nameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    radiusController.dispose();
    super.dispose();
  }

  Future<void> createDestination() async {
    final latitude = double.tryParse(latitudeController.text.trim());
    final longitude = double.tryParse(longitudeController.text.trim());
    final radius = int.tryParse(radiusController.text.trim());

    if (nameController.text.trim().isEmpty ||
        latitude == null ||
        longitude == null ||
        radius == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid destination details")),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await service.createDestination({
        "name": nameController.text.trim(),
        "type": type,
        "latitude": latitude,
        "longitude": longitude,
        "radius": radius,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Destination Created")));

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Destination")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Destination Name"),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              initialValue: type,
              decoration: const InputDecoration(labelText: "Type"),
              items: const [
                DropdownMenuItem(value: "BERTH", child: Text("BERTH")),
                DropdownMenuItem(value: "YARD", child: Text("YARD")),
                DropdownMenuItem(value: "TRANSIT", child: Text("TRANSIT")),
              ],
              onChanged: loading
                  ? null
                  : (value) {
                      if (value == null) return;

                      setState(() {
                        type = value;
                      });
                    },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: latitudeController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: const InputDecoration(labelText: "Latitude"),
            ),
            TextField(
              controller: longitudeController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: const InputDecoration(labelText: "Longitude"),
            ),
            TextField(
              controller: radiusController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              decoration: const InputDecoration(labelText: "Radius"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : createDestination,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Create Destination"),
            ),
          ],
        ),
      ),
    );
  }
}
