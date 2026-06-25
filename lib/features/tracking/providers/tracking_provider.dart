import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/location_service.dart';

final trackingProvider = NotifierProvider<TrackingNotifier, TrackingState>(
  TrackingNotifier.new,
);

class TrackingState {
  final bool tracking;
  final String? tripId;
  final String? errorMessage;

  const TrackingState({required this.tracking, this.tripId, this.errorMessage});

  const TrackingState.initial()
    : tracking = false,
      tripId = null,
      errorMessage = null;

  TrackingState copyWith({
    bool? tracking,
    String? tripId,
    String? errorMessage,
  }) {
    return TrackingState(
      tracking: tracking ?? this.tracking,
      tripId: tripId ?? this.tripId,
      errorMessage: errorMessage,
    );
  }
}

class TrackingNotifier extends Notifier<TrackingState> {
  @override
  TrackingState build() {
    return const TrackingState.initial();
  }

  Future<void> start(String tripId) async {
    final started = await LocationService.startTracking(tripId);

    state = TrackingState(
      tracking: started,
      tripId: started ? tripId : null,
      errorMessage: started ? null : "Location permission is required",
    );
  }

  Future<void> stop() async {
    await LocationService.stopTracking();
    state = const TrackingState.initial();
  }
}
