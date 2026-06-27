import 'package:flutter/material.dart';

import '../../../core/network/api_response_parser.dart';
import '../models/cargo_type_model.dart';
import '../services/cargo_type_service.dart';
import '../widgets/cargo_type_card.dart';
import 'create_cargo_type_screen.dart';

class CargoTypesScreen extends StatefulWidget {
  const CargoTypesScreen({super.key});

  @override
  State<CargoTypesScreen> createState() => _CargoTypesScreenState();
}

class _CargoTypesScreenState extends State<CargoTypesScreen> {
  final service = CargoTypeService();

  List<CargoTypeModel> cargoTypes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCargoTypes();
  }

  Future<void> loadCargoTypes() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await service.getCargoTypes();

      final items = ApiResponseParser.listFrom(
        response.data,
        keys: const ["data", "cargo", "cargoTypes", "items", "results"],
      );

      if (!mounted) return;

      setState(() {
        cargoTypes = items
            .map((e) => CargoTypeModel.fromJson(Map<String, dynamic>.from(e)))
            .where((cargoType) => cargoType.id.isNotEmpty)
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

  Future<void> openCreateCargoType() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CreateCargoTypeScreen()),
    );

    if (created == true) {
      loadCargoTypes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cargo Types")),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreateCargoType,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : cargoTypes.isEmpty
          ? const Center(child: Text("No cargo types found"))
          : RefreshIndicator(
              onRefresh: loadCargoTypes,
              child: ListView.builder(
                itemCount: cargoTypes.length,
                itemBuilder: (_, index) {
                  return CargoTypeCard(
                    cargoType: cargoTypes[index],
                  );
                },
              ),
            ),
    );
  }
}
