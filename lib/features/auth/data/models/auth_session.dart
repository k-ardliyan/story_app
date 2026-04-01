class AuthSession {
  const AuthSession({
    required this.userId,
    required this.name,
    required this.token,
  });

  final String userId;
  final String name;
  final String token;

  factory AuthSession.fromLoginResult(Map<String, dynamic> json) {
    return AuthSession(
      userId: (json['userId'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      token: (json['token'] as String?) ?? '',
    );
  }

  bool get isValid => token.isNotEmpty;
}
