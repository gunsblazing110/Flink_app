enum UserRole { hqAdmin, hubManager, unknown }

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final UserRole role;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? 'User',
      role: _roleFromString(data['role'] as String?),
    );
  }

  static UserRole _roleFromString(String? value) {
    switch (value) {
      case 'hq_admin':
        return UserRole.hqAdmin;
      case 'hub_manager':
        return UserRole.hubManager;
      default:
        return UserRole.unknown;
    }
  }

  bool get isHqAdmin => role == UserRole.hqAdmin;
  bool get isHubManager => role == UserRole.hubManager;

  String get roleLabel {
    switch (role) {
      case UserRole.hqAdmin:
        return 'HQ Admin';
      case UserRole.hubManager:
        return 'Hub Manager';
      case UserRole.unknown:
        return 'No Role Assigned';
    }
  }
}
