import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';
import '../flinkcooks/flink_cooks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlinkColors.white,
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                const _ComingSoonScreen(label: 'Discover'),
                const _ComingSoonScreen(label: 'Offers'),
                const FlinkCooksScreen(),
                const _ComingSoonScreen(label: 'Cart'),
                const _ComingSoonScreen(label: 'Profile'),
              ],
            ),
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
          onTap: (index) => setState(() => _selectedIndex = index),
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined),
              activeIcon: Icon(Icons.local_offer),
              label: 'Offers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Flink Cooks°',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      decoration: BoxDecoration(
        color: FlinkColors.white,
        border: Border(
          bottom: BorderSide(color: FlinkColors.midGrey, width: 0.8),
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