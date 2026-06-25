import 'package:flutter/material.dart';

import '../models/driver_model.dart';

class DriverCard
    extends StatelessWidget {

  final DriverModel driver;

  final VoidCallback onToggle;

  const DriverCard({
    super.key,
    required this.driver,
    required this.onToggle,
  });

  @override
  Widget build(
      BuildContext context) {

    return Card(

      child: ListTile(

        title:
            Text(driver.name),

        subtitle:
            Text(driver.mobile),

        trailing:
            Switch(
          value:
              driver.isActive,
          onChanged:
              (_) => onToggle(),
        ),
      ),
    );
  }
}