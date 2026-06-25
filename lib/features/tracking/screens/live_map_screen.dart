import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/network/api_response_parser.dart';
import '../models/truck_location.dart';
import '../services/tracking_service.dart';
import '../services/socket_service.dart';

class LiveMapScreen
    extends StatefulWidget {

  const LiveMapScreen({
    super.key,
  });

  @override
  State<LiveMapScreen>
      createState() =>
          _LiveMapScreenState();
}

class _LiveMapScreenState
    extends State<LiveMapScreen> {

  final trackingService =
      TrackingService();

  final Map<String, TruckLocation>
      truckLocations = {};

  @override
  void initState() {
    super.initState();

    loadLocations();

    initializeSocket();
  }

  Future<void> loadLocations()
      async {

    try {

      final response =
          await trackingService
              .getLiveLocations();

      final locations =
          ApiResponseParser.listFrom(
        response.data,
        keys: const [
          "data",
          "locations",
          "trucks",
          "liveLocations",
        ],
      );

      for (final item
          in locations) {

        final truck =
            TruckLocation
                .fromJson(
          Map<String, dynamic>.from(
            item,
          ),
        );

        truckLocations[
            truck.truckId] = truck;
      }

      setState(() {});

    } catch (e) {

      debugPrint(
        e.toString(),
      );
    }
  }

  void initializeSocket() {

    SocketService.connect();

    SocketService.socket.on(
      "truck:update",

      (data) {

        final truck =
            TruckLocation
                .fromJson(
          ApiResponseParser.mapFrom(
            data,
            keys: const [
              "data",
              "location",
              "truck",
            ],
          ),
        );

        setState(() {

          truckLocations[
              truck.truckId] =
              truck;
        });
      },
    );
  }

  @override
  void dispose() {

    SocketService.disconnect();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
          "Live Truck Tracking",
        ),
      ),

      body: FlutterMap(
        options:
            const MapOptions(
          initialCenter:
              LatLng(
            9.2876,
            79.3129,
          ),
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName:
                'com.voc.trucktracking',
          ),
          MarkerLayer(
            markers:
                truckLocations.values
                    .map(
                      _buildTruckMarker,
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Marker _buildTruckMarker(
      TruckLocation truck) {

    return Marker(
      point: LatLng(
        truck.latitude,
        truck.longitude,
      ),
      width: 56,
      height: 56,
      child: Tooltip(
        message:
            truck.truckNumber,
        child: const Icon(
          Icons.local_shipping,
          size: 40,
          color: Colors.blue,
        ),
      ),
    );
  }
}
