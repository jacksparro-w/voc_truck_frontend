import 'package:flutter/material.dart';

import '../models/cargo_type_model.dart';

class CargoTypeCard extends StatelessWidget {
  final CargoTypeModel cargoType;

  const CargoTypeCard({
    super.key,
    required this.cargoType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: ListTile(
        leading: const Icon(
          Icons.inventory_2,
          color: Colors.deepOrange,
        ),
        title: Text(
          cargoType.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
