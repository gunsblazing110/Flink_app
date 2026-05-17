import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/unauthorized_screen.dart';
import '../screens/hq_admin/recipe_management_page.dart';
import '../screens/hub_manager/hub_inventory_page.dart';
import '../screens/home/home_screen.dart';

class AppRouter {
  static GoRouter create(FlinkcooksAuthProvider auth) {
    return GoRouter(
      refreshListenable: auth,
      initialLocation: '/login',
      redirect: (BuildContext context, GoRouterState state) {
        if (auth.isLoading) return null;

        final location = state.matchedLocation;
        final isLoggedIn = auth.isAuthenticated;
        final role = auth.currentUser?.role;

        if (!isLoggedIn) {
          return (location == '/login' || location == '/register')
              ? null
              : '/login';
        }

        // Regular customers (no staff role) go to the customer home screen.
        // They cannot access /admin or /hub routes — the checks below redirect
        // any staff-only path back to /home for them.
        if (role == UserRole.unknown) {
          if (location.startsWith('/admin') || location.startsWith('/hub')) {
            return '/home';
          }
          return location == '/home' ? null : '/home';
        }

        if (location == '/login' || location == '/register') {
          return role == UserRole.hqAdmin ? '/admin/recipes' : '/hub/inventory';
        }

        if (role == UserRole.hubManager && location.startsWith('/admin')) {
          return '/unauthorized';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (ctx, st) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (ctx, st) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/unauthorized',
          builder: (ctx, st) => const UnauthorizedScreen(),
        ),
        GoRoute(
          path: '/admin/recipes',
          builder: (ctx, st) => const RecipeManagementPage(),
        ),
        GoRoute(
          path: '/hub/inventory',
          builder: (ctx, st) => const HubInventoryPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (ctx, st) => const HomeScreen(),
        ),
      ],
    );
  }
}
