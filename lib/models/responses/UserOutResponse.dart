class UserOutResponse {
  final int id;
  final String name;
  final String email;
  final DateTime createdAt;

  const UserOutResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory UserOutResponse.fromJson(Map<String, dynamic> json) {
    return UserOutResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
