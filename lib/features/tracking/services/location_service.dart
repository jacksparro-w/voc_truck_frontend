import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'gps_service.dart';
import 'tracking_api_service.dart';

const trackingBackgroundTask = "truckTrackingBackgroundTask";
const trackingBackgroundTaskName = "truck_tracking_background_location";

bool get _supportsBackgroundTracking {
  if (kIsWeb) {
    return false;
  }

  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
}

@pragma('vm:entry-point')
void trackingCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final tripId = inputData?["tripId"] as String?;

    if (tripId == null || tripId.isEmpty) {
      return true;
    }

    try {
      final hasPermission = await GpsService.requestPermission();

      if (!hasPermission) {
        return false;
      }

      final position = await GpsService.getCurrentPosition();
      final api = TrackingApiService();

      await api.retryQueuedLocations();
      await api.sendLocation(
        tripId: tripId,
        latitude: position.latitude,
        longitude: position.longitude,
        speed: position.speed,
        heading: position.heading,
      );

      return true;
    } catch (_) {
      return false;
    }
  });
}

class LocationService {
  static Timer? _timer;
  static final api = TrackingApiService();

  static Future<void> initializeBackgroundTracking() async {
    if (!_supportsBackgroundTracking) {
      return;
    }

    await Workmanager().initialize(trackingCallbackDispatcher);
  }

  static Future<bool> startTracking(String tripId) async {
    final hasPermission = await GpsService.requestPermission();

    if (!hasPermission) {
      return false;
    }

    await _saveActiveTripId(tripId);
    await _startBackgroundTracking(tripId);

    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _sendCurrentLocation(tripId),
    );

    await _sendCurrentLocation(tripId);

    return true;
  }

  static Future<void> stopTracking() async {
    _timer?.cancel();
    _timer = null;

    if (_supportsBackgroundTracking) {
      await Workmanager().cancelByUniqueName(trackingBackgroundTaskName);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("active_tracking_trip_id");
  }

  static Future<void> resumeActiveTracking() async {
    final prefs = await SharedPreferences.getInstance();
    final tripId = prefs.getString("active_tracking_trip_id");

    if (tripId == null || tripId.isEmpty) {
      return;
    }

    await startTracking(tripId);
  }

  static Future<void> _sendCurrentLocation(String tripId) async {
    try {
      final position = await GpsService.getCurrentPosition();

      await api.retryQueuedLocations();
      await api.sendLocation(
        tripId: tripId,
        latitude: position.latitude,
        longitude: position.longitude,
        speed: position.speed,
        heading: position.heading,
      );
    } catch (_) {
      // Failed sends are queued by TrackingApiService when the API call is reached.
    }
  }

  static Future<void> _saveActiveTripId(String tripId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("active_tracking_trip_id", tripId);
  }

  static Future<void> _startBackgroundTracking(String tripId) async {
    if (!_supportsBackgroundTracking) {
      return;
    }

    await Workmanager().cancelByUniqueName(trackingBackgroundTaskName);

    await Workmanager().registerPeriodicTask(
      trackingBackgroundTaskName,
      trackingBackgroundTask,
      frequency: const Duration(minutes: 15),
      inputData: {"tripId": tripId},
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}
