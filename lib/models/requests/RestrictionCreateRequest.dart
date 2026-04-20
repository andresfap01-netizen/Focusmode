class RestrictionCreateRequest {
  final String appKey;
  final String appName;
  final String platform;
  final int minutesLimit;
  final DateTime? startedAt;

  const RestrictionCreateRequest({
    required this.appKey,
    required this.appName,
    required this.platform,
    required this.minutesLimit,
    this.startedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'app_key': appKey,
      'app_name': appName,
      'platform': platform,
      'minutes_limit': minutesLimit,
      'started_at': startedAt?.toIso8601String(),
    };
  }
}
