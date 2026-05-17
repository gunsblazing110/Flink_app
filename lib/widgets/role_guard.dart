import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';

/// Wrap any widget with this to make it visible only to a specific role.
/// Usage: RoleGuard(role: UserRole.hqAdmin, child: AddRecipeButton())
class RoleGuard extends StatelessWidget {
  final UserRole role;
  final Widget child;
  final Widget? fallback;

  const RoleGuard({
    super.key,
    required this.role,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final currentRole =
        context.watch<FlinkcooksAuthProvider>().currentUser?.role;
    if (currentRole == role) return child;
    return fallback ?? const SizedBox.shrink();
  }
}
