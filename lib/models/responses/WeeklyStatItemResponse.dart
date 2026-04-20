class WeeklyStatItemResponse {
  final String appKey;
  final String appName;
  final int totalMinutes;
  final double percentage;

  const WeeklyStatItemResponse({
    required this.appKey,
    required this.appName,
    required this.totalMinutes,
    required this.percentage,
  });

  factory WeeklyStatItemResponse.fromJson(Map<String, dynamic> json) {
    return WeeklyStatItemResponse(
      appKey: json['app_key'] as String,
      appName: json['app_name'] as String,
      totalMinutes: json['total_minutes'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}
