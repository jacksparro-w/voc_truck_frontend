import 'package:flutter/material.dart';

import '../../../core/network/api_response_parser.dart';
import '../models/trip_history_model.dart';
import '../services/trip_service.dart';
import '../widgets/trip_history_card.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({
    super.key,
  });

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  final service = TripService();

  List<TripHistoryModel> trips = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTrips();
  }

  Future<void> loadTrips() async {
    try {
      final response = await service.getHistory();

      final items = ApiResponseParser.listFrom(
        response.data,
        keys: const [
          "data",
          "trips",
          "history",
          "items",
          "results",
        ],
      );

      if (!mounted) return;

      setState(() {
        trips = items
            .map(
              (e) => TripHistoryModel.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList();
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trip History",
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : trips.isEmpty
              ? const Center(
                  child: Text(
                    "No trips found",
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadTrips,
                  child: ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (_, index) {
                      return TripHistoryCard(
                        trip: trips[index],
                      );
                    },
                  ),
                ),
    );
  }
}
