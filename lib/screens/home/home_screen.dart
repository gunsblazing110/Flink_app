import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';
import '../flinkcooks/flink_cooks_screen.dart';
import '../cart/cart_screen.dart';
import '../cart/cart_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _cartService.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    setState(() {});
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const _ComingSoonScreen(label: 'Discover');
      case 1:
        return const _ComingSoonScreen(label: 'Offers');
      case 2:
        return const FlinkCooksScreen();
      case 3:
        return const CartScreen();
      case 4:
        return const _ComingSoonScreen(label: 'Profile');
      default:
        return const _ComingSoonScreen(label: 'Discover');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlinkColors.white,
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: _buildScreen(_selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: FlinkColors.midGrey, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) =>
              setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: FlinkColors.white,
          selectedItemColor: FlinkColors.pink,
          unselectedItemColor: FlinkColors.textGrey,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Discover',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined),
              activeIcon: Icon(Icons.local_offer),
              label: 'Offers',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Flink Cooks°',
            ),
            BottomNavigationBarItem(
              icon: _buildCartIcon(isActive: false),
              activeIcon: _buildCartIcon(isActive: true),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartIcon({required bool isActive}) {
    final count = _cartService.totalItemCount;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          isActive
              ? Icons.shopping_cart
              : Icons.shopping_cart_outlined,
          color: isActive
              ? FlinkColors.pink
              : FlinkColors.textGrey,
        ),
        if (count > 0)
          Positioned(
            top: -6,
            right: -8,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: FlinkColors.pink,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: FlinkColors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTopBar() {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      decoration: BoxDecoration(
        color: FlinkColors.white,
        border: Border(
          bottom: BorderSide(
              color: FlinkColors.midGrey, width: 0.8),
        ),
      ),
      padding: EdgeInsets.only(
        top: topPadding + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Row(
        children: [
          const FlinkLogo(),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: FlinkColors.pink.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: FlinkColors.pink.withOpacity(0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on,
                      color: FlinkColors.pink, size: 16),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Enter your delivery address',
                      style: TextStyle(
                        color: FlinkColors.pink,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout_outlined,
                color: FlinkColors.textGrey, size: 22),
            tooltip: 'Sign out',
          ),
        ],
      ),
    );
  }
}

class _ComingSoonScreen extends StatelessWidget {
  final String label;
  const _ComingSoonScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: FlinkColors.pink.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt,
              color: FlinkColors.pink,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '$label — Coming Soon...',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: FlinkColors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'We are working on something great.',
            style: TextStyle(
              fontSize: 15,
              color: FlinkColors.textGrey,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Stay tuned!',
            style: TextStyle(
              fontSize: 15,
              color: FlinkColors.pink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}