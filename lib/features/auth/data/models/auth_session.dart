import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

@freezed
class AuthSession with _$AuthSession {
  const AuthSession._();

  const factory AuthSession({
    @Default('') String userId,
    @Default('') String name,
    @Default('') String token,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);

  factory AuthSession.fromLoginResult(Map<String, dynamic> json) =>
      AuthSession.fromJson(json);

  bool get isValid => token.isNotEmpty;
}
