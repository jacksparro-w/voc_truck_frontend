import 'package:flutter/material.dart';

import '../../../core/network/api_response_parser.dart';
import '../models/destination_model.dart';
import '../services/destination_service.dart';
import '../widgets/destination_card.dart';
import 'create_destination_screen.dart';

class DestinationsScreen extends StatefulWidget {
  const DestinationsScreen({super.key});

  @override
  State<DestinationsScreen> createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen> {
  final service = DestinationService();

  final destinationTypes = const ["ALL", "BERTH", "YARD", "TRANSIT"];

  List<DestinationModel> destinations = [];
  String selectedType = "ALL";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDestinations();
  }

  Future<void> loadDestinations() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await service.getDestinations(
        type: selectedType == "ALL" ? null : selectedType,
      );

      final items = ApiResponseParser.listFrom(
        response.data,
        keys: const ["data", "destinations", "items", "results"],
      );

      if (!mounted) return;

      setState(() {
        destinations = items
            .map((e) => DestinationModel.fromJson(Map<String, dynamic>.from(e)))
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

  Future<void> openCreateDestination() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CreateDestinationScreen()),
    );

    if (created == true) {
      loadDestinations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Destinations")),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreateDestination,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: const InputDecoration(labelText: "Filter By Type"),
              items: destinationTypes
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedType = value;
                });

                loadDestinations();
              },
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : destinations.isEmpty
                ? const Center(child: Text("No destinations found"))
                : RefreshIndicator(
                    onRefresh: loadDestinations,
                    child: ListView.builder(
                      itemCount: destinations.length,
                      itemBuilder: (_, index) {
                        return DestinationCard(
                          destination: destinations[index],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
