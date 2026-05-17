import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

class UnauthorizedScreen extends StatelessWidget {
  const UnauthorizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<FlinkcooksAuthProvider>();
    final hasNoRole = auth.currentUser?.role == UserRole.unknown;

    return Scaffold(
      backgroundColor: FlinkColors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: FlinkColors.pink.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 52,
                  color: FlinkColors.pink,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                hasNoRole ? 'No Role Assigned' : 'Access Denied',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: FlinkColors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                hasNoRole
                    ? 'Your account was created but has no role yet.\n'
                        'Please contact your HQ Admin to assign your role.'
                    : 'This area is restricted. You do not have access.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: FlinkColors.textGrey,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () => auth.signOut(),
                icon: const Icon(Icons.logout, color: FlinkColors.pink),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: FlinkColors.pink,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(160, 48),
                  side: const BorderSide(color: FlinkColors.pink, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
