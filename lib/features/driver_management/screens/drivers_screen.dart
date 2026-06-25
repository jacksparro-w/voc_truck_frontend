import 'package:flutter/material.dart';

import '../../../core/network/api_response_parser.dart';
import '../models/driver_model.dart';
import '../services/driver_management_service.dart';
import '../widgets/driver_card.dart';
import 'create_driver_screen.dart';

class DriversScreen
    extends StatefulWidget {

  const DriversScreen({
    super.key,
  });

  @override
  State<DriversScreen>
      createState() =>
          _DriversScreenState();
}

class _DriversScreenState
    extends State<DriversScreen> {

  final service =
      DriverManagementService();

  List<DriverModel> drivers =
      [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadDrivers();
  }

  Future<void> loadDrivers()
      async {
    setState(() {
      loading = true;
    });

    try {

      final response =
          await service
              .getDrivers();

      final items =
          ApiResponseParser
              .listFrom(response.data);

      if (!mounted) return;

      drivers =
          items
              .map(
                (e) =>
                    DriverModel
                        .fromJson(
                      Map<String, dynamic>
                          .from(e),
                    ),
              )
              .toList();

      setState(() {
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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
          "Drivers",
        ),
      ),

      floatingActionButton:
          FloatingActionButton(

        child:
            const Icon(Icons.add),

        onPressed: () {

          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) =>
                  const CreateDriverScreen(),
            ),
          );
        },
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : ListView.builder(

              itemCount:
                  drivers.length,

              itemBuilder:
                  (_, index) {

                final driver =
                    drivers[index];

                return DriverCard(

                  driver: driver,

                  onToggle:
                      () async {

                    await service
                        .updateStatus(
                      driver.id,
                      !driver.isActive,
                    );

                    loadDrivers();
                  },
                );
              },
            ),
    );
  }
}
