class UserModel {
  final int id;
  final String firebaseUid;
  final String email;
  final String name;
  final String role;
  final bool emailVerified;
  final String createdAt;


  const UserModel({
    required this.id,
    required this.firebaseUid,
    required this.email,
    required this.name,
    required this.role,
    required this.emailVerified,
    required this.createdAt,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
id: (json['id'] as num?)?.toInt() ?? 0,
firebaseUid: json['firebase_uid'] ?? '',
email: json['email'] ?? '',
name: json['name'] ?? '',
role: json['role'] ?? '',
emailVerified: json['email_verified'] == true || json['email_verified'] == 1,
createdAt: json['created_at'] ?? '',
);
}


class AuthResponseModel {
  final bool success;
  final String message;
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final UserModel user;


  const AuthResponseModel({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,

required this.user,
  });


  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
  final data = json['data'] ?? {};

  return AuthResponseModel(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    accessToken: data['access_token'] ?? '',
    tokenType: data['token_type'] ?? '',
    expiresIn: (data['expires_in'] as num?)?.toInt() ?? 0,
    user: UserModel.fromJson(data['user'] ?? {}),
  );
}
}
