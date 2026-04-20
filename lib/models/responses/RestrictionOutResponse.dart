class RestrictionOutResponse {
  final int id;
  final int userId;
  final String appKey;
  final String appName;
  final String platform;
  final int minutesLimit;
  final DateTime? startedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RestrictionOutResponse({
    required this.id,
    required this.userId,
    required this.appKey,
    required this.appName,
    required this.platform,
    required this.minutesLimit,
    required this.startedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RestrictionOutResponse.fromJson(Map<String, dynamic> json) {
    return RestrictionOutResponse(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      appKey: json['app_key'] as String,
      appName: json['app_name'] as String,
      platform: json['platform'] as String,
      minutesLimit: json['minutes_limit'] as int,
      startedAt: json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
