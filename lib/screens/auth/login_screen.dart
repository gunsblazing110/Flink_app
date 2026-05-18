import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'register_screen.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await context.read<FlinkcooksAuthProvider>().signIn(
          _emailController.text,
          _passwordController.text,
        );
    if (mounted) setState(() => _isLoading = false);
  }

  void _showForgotDialog() {
    final ctrl = TextEditingController(text: _emailController.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Reset Password',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "We'll send a reset link to your email.",
              style: TextStyle(
                  color: FlinkColors.textGrey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email address',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: FlinkColors.textGrey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = ctrl.text.trim();
              if (email.isNotEmpty) {
                final nav = Navigator.of(ctx);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email);
                  nav.pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Reset link sent to $email'),
                      backgroundColor: FlinkColors.pink,
                    ),
                  );
                } catch (e) {
                  nav.pop();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 40),
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<FlinkcooksAuthProvider>();

    return Scaffold(
      backgroundColor: FlinkColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                const FlinkLogo(),

                const SizedBox(height: 40),

                const Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: FlinkColors.black,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sign in to continue.',
                  style: TextStyle(
                    fontSize: 15,
                    color: FlinkColors.textGrey,
                  ),
                ),

                const SizedBox(height: 32),

                if (auth.errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: FlinkColors.pink.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color:
                              FlinkColors.pink.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: FlinkColors.pink, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            auth.errorMessage!,
                            style: const TextStyle(
                              color: FlinkColors.pink,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    prefixIcon: Icon(Icons.email_outlined,
                        color: FlinkColors.textGrey, size: 20),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _isLoading ? null : _login(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: FlinkColors.textGrey, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: FlinkColors.textGrey,
                        size: 20,
                      ),
                      onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Password is required'
                      : null,
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _showForgotDialog,
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: FlinkColors.pink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: FlinkColors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text('Sign In'),
                ),

                const SizedBox(height: 28),

                const Row(
                  children: [
                    Expanded(
                        child: Divider(color: FlinkColors.midGrey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: TextStyle(
                            color: FlinkColors.textGrey,
                            fontSize: 13),
                      ),
                    ),
                    Expanded(
                        child: Divider(color: FlinkColors.midGrey)),
                  ],
                ),

                const SizedBox(height: 28),

                OutlinedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const RegisterScreen()),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    side: const BorderSide(
                        color: FlinkColors.pink, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: FlinkColors.pink,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FlinkLogo extends StatelessWidget {
  const FlinkLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: FlinkColors.pink,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.bolt,
            color: FlinkColors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Flink',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: FlinkColors.pink,
            letterSpacing: -0.5,
          ),
        ),
        const Text(
          '°',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: FlinkColors.pink,
          ),
        ),
      ],
    );
  }
}