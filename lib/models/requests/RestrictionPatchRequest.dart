class RestrictionPatchRequest {
  final String? appName;
  final String? platform;
  final int? minutesLimit;
  final DateTime? startedAt;

  const RestrictionPatchRequest({
    this.appName,
    this.platform,
    this.minutesLimit,
    this.startedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'app_name': appName,
      'platform': platform,
      'minutes_limit': minutesLimit,
      'started_at': startedAt?.toIso8601String(),
    };
  }
}
