import 'package:flutter/material.dart';

import '../../../core/network/api_response_parser.dart';
import '../../destination_management/models/destination_model.dart';
import '../../destination_management/services/destination_service.dart';
import '../../truck_management/models/truck_model.dart';
import '../../truck_management/services/truck_management_service.dart';
import '../../tracking/services/location_service.dart';
import '../models/cargo_type_model.dart';
import '../models/start_trip_request.dart';
import '../services/trip_service.dart';

class StartTripScreen extends StatefulWidget {
  const StartTripScreen({super.key});

  @override
  State<StartTripScreen> createState() => _StartTripScreenState();
}

class _StartTripScreenState extends State<StartTripScreen> {
  final service = TripService();
  final truckService = TruckManagementService();
  final destinationService = DestinationService();

  List<TruckModel> trucks = [];
  List<CargoTypeModel> cargoTypes = [];
  List<DestinationModel> destinations = [];

  String? selectedTruckId;
  String? selectedCargoTypeId;
  String? selectedDestinationId;

  String cargoStatus = "LOADED";
  bool loadingOptions = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadOptions();
  }

  Future<void> loadOptions() async {
    setState(() {
      loadingOptions = true;
    });

    try {
      final responses = await Future.wait([
        truckService.getTrucks(),
        service.getCargoTypes(),
        destinationService.getDestinations(),
      ]);

      if (!mounted) return;

      final truckItems = ApiResponseParser.listFrom(
        responses[0].data,
        keys: const ["data", "trucks", "items", "results"],
      );
      final cargoItems = ApiResponseParser.listFrom(
        responses[1].data,
        keys: const ["data", "cargo", "cargoTypes", "items", "results"],
      );
      final destinationItems = ApiResponseParser.listFrom(
        responses[2].data,
        keys: const ["data", "destinations", "items", "results"],
      );

      setState(() {
        trucks = truckItems
            .map((e) => TruckModel.fromJson(Map<String, dynamic>.from(e)))
            .where((truck) => truck.id.isNotEmpty)
            .toList();
        cargoTypes = cargoItems
            .map((e) => CargoTypeModel.fromJson(Map<String, dynamic>.from(e)))
            .where((cargoType) => cargoType.id.isNotEmpty)
            .toList();
        destinations = destinationItems
            .map((e) => DestinationModel.fromJson(Map<String, dynamic>.from(e)))
            .where((destination) => destination.id.isNotEmpty)
            .toList();

        selectedTruckId = trucks.isEmpty ? null : trucks.first.id;
        selectedCargoTypeId = cargoTypes.isEmpty ? null : cargoTypes.first.id;
        selectedDestinationId =
            destinations.isEmpty ? null : destinations.first.id;
        loadingOptions = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingOptions = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unable to load trip options: $e"),
        ),
      );
    }
  }

  Future<void> startTrip() async {
    final needsCargoType = cargoStatus == "LOADED";

    if (selectedTruckId == null ||
        selectedDestinationId == null ||
        (needsCargoType && selectedCargoTypeId == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select truck, cargo, and destination"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    final request = StartTripRequest(
      truckId: selectedTruckId!,
      cargoStatus: cargoStatus,
      cargoTypeId: needsCargoType ? selectedCargoTypeId! : "",
      destinationId: selectedDestinationId!,
    );

    try {
      final response = await service.startTrip(request.toJson());

      final tripData = ApiResponseParser.mapFrom(response.data);
      final tripId = tripData["id"] ?? tripData["_id"];

      if (tripId != null) {
        await LocationService.startTracking(tripId.toString());
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Trip Started")));

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
      appBar: AppBar(title: const Text("Start Trip")),
      body: loadingOptions
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadOptions,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedTruckId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "Truck",
                      prefixIcon: Icon(Icons.local_shipping),
                    ),
                    items: trucks
                        .map(
                          (truck) => DropdownMenuItem(
                            value: truck.id,
                            child: Text(
                              "${truck.truckNumber} - ${truck.status}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: loading
                        ? null
                        : (value) {
                            setState(() {
                              selectedTruckId = value;
                            });
                          },
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: cargoStatus,
                    decoration: const InputDecoration(
                      labelText: "Cargo Status",
                      prefixIcon: Icon(Icons.inventory_2),
                    ),
                    items: const [
                      DropdownMenuItem(value: "LOADED", child: Text("LOADED")),
                      DropdownMenuItem(value: "EMPTY", child: Text("EMPTY")),
                    ],
                    onChanged: loading
                        ? null
                        : (value) {
                            if (value == null) return;

                            setState(() {
                              cargoStatus = value;
                              if (value == "EMPTY") {
                                selectedCargoTypeId = null;
                              } else if (selectedCargoTypeId == null &&
                                  cargoTypes.isNotEmpty) {
                                selectedCargoTypeId = cargoTypes.first.id;
                              }
                            });
                          },
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: cargoStatus == "EMPTY" ? null : selectedCargoTypeId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: cargoStatus == "EMPTY"
                          ? "Cargo Type not required"
                          : "Cargo Type",
                      prefixIcon: const Icon(Icons.category),
                    ),
                    items: cargoTypes
                        .map(
                          (cargoType) => DropdownMenuItem(
                            value: cargoType.id,
                            child: Text(
                              cargoType.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: loading || cargoStatus == "EMPTY"
                        ? null
                        : (value) {
                            setState(() {
                              selectedCargoTypeId = value;
                            });
                          },
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedDestinationId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "Destination",
                      prefixIcon: Icon(Icons.place),
                    ),
                    items: destinations
                        .map(
                          (destination) => DropdownMenuItem(
                            value: destination.id,
                            child: Text(
                              "${destination.name} - ${destination.type}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: loading
                        ? null
                        : (value) {
                            setState(() {
                              selectedDestinationId = value;
                            });
                          },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: loading ? null : startTrip,
                    icon: loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.play_arrow),
                    label: const Text("START TRIP"),
                  ),
                ],
              ),
            ),
    );
  }
}
