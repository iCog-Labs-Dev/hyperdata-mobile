import 'package:leyu_mobile/features/auth/data/models/user.dart';

class LoginResponse {
  final User user;
  final String accessToken;
  final String refreshToken;

  LoginResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json['data']['user']),
      accessToken: json['data']['access_token'],
      refreshToken: json['data']['refresh_token'],
    );
  }
}
