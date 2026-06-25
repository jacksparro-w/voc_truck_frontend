import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/dio_client.dart';
import '../models/location_model.dart';

class TrackingApiService {
  static const _offlineQueueKey = "offline_tracking_locations";

  Future<void> sendLocation({
    required String tripId,
    required double latitude,
    required double longitude,
    required double speed,
    required double heading,
  }) async {
    final location = LocationModel(
      latitude: latitude,
      longitude: longitude,
      speed: speed,
      heading: heading,
    );

    try {
      await _postLocation(tripId: tripId, location: location);
    } catch (_) {
      await _queueLocation(tripId: tripId, location: location);

      rethrow;
    }
  }

  Future<void> retryQueuedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final queued = prefs.getStringList(_offlineQueueKey) ?? [];

    if (queued.isEmpty) return;

    final pending = <String>[];

    for (final item in queued) {
      try {
        final data = Map<String, dynamic>.from(jsonDecode(item));

        await _postLocation(
          tripId: data["tripId"] ?? "",
          location: LocationModel.fromJson(
            Map<String, dynamic>.from(data["location"] ?? {}),
          ),
        );
      } catch (_) {
        pending.add(item);
      }
    }

    await prefs.setStringList(_offlineQueueKey, pending);
  }

  Future<void> _postLocation({
    required String tripId,
    required LocationModel location,
  }) async {
    await DioClient.dio.post(
      "/tracking/location",
      data: {"tripId": tripId, ...location.toJson()},
    );
  }

  Future<void> _queueLocation({
    required String tripId,
    required LocationModel location,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final queued = prefs.getStringList(_offlineQueueKey) ?? [];

    queued.add(jsonEncode({"tripId": tripId, "location": location.toJson()}));

    await prefs.setStringList(_offlineQueueKey, queued);
  }
}
