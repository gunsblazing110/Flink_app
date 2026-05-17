import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final auth = FlinkcooksAuthProvider();

  runApp(
    ChangeNotifierProvider.value(
      value: auth,
      child: _FlinkApp(auth: auth),
    ),
  );
}

class _FlinkApp extends StatefulWidget {
  final FlinkcooksAuthProvider auth;
  const _FlinkApp({required this.auth});

  @override
  State<_FlinkApp> createState() => _FlinkAppState();
}

class _FlinkAppState extends State<_FlinkApp> {
  late final GoRouter _router = AppRouter.create(widget.auth);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flink',
      debugShowCheckedModeBanner: false,
      theme: FlinkTheme.theme,
      routerConfig: _router,
    );
  }
}
