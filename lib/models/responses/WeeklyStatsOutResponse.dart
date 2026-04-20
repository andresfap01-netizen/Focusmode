import 'package:focusmode/models/responses/WeeklyStatItemResponse.dart';

class WeeklyStatsOutResponse {
  final int weekTotalMinutes;
  final List<WeeklyStatItemResponse> items;

  const WeeklyStatsOutResponse({
    required this.weekTotalMinutes,
    required this.items,
  });

  factory WeeklyStatsOutResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? []);
    return WeeklyStatsOutResponse(
      weekTotalMinutes: json['week_total_minutes'] as int,
      items: rawItems
          .map(
            (item) =>
                WeeklyStatItemResponse.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
