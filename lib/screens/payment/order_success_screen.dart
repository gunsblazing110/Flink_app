import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../cart/cart_service.dart';
import '../../theme/app_theme.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final Animation<double> _checkScale;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _detailsSlide;
  late final Animation<double> _detailsFade;
  late final String _orderNumber;

  @override
  void initState() {
    super.initState();
    _orderNumber =
        '#FL-${20000 + DateTime.now().millisecondsSinceEpoch % 9999}';

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _checkScale = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
    );

    _titleFade = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.35, 0.65, curve: Curves.easeIn),
    );

    _detailsSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.5, 0.88, curve: Curves.easeOut),
    ));

    _detailsFade = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.5, 0.88, curve: Curves.easeIn),
    );

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _LottieDelivery(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    ScaleTransition(
                      scale: _checkScale,
                      child: Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.green.shade300,
                              width: 2.5),
                        ),
                        child: Icon(Icons.check_rounded,
                            color: Colors.green.shade500,
                            size: 48),
                      ),
                    ),
                    const SizedBox(height: 14),
                    FadeTransition(
                      opacity: _titleFade,
                      child: const Column(
                        children: [
                          Text(
                            'Order Placed!',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: FlinkColors.black,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Your ingredients are being picked',
                            style: TextStyle(
                                fontSize: 14,
                                color: FlinkColors.textGrey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    SlideTransition(
                      position: _detailsSlide,
                      child: FadeTransition(
                        opacity: _detailsFade,
                        child: _OrderDetailsCard(
                            orderNumber: _orderNumber),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: ElevatedButton(
                onPressed: () {
                  CartService().clear();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlinkColors.pink,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Back to Dashboard',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderDetailsCard extends StatelessWidget {
  final String orderNumber;
  const _OrderDetailsCard({required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlinkColors.lightGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlinkColors.midGrey),
      ),
      child: Column(
        children: [
          _Row(
              icon: Icons.confirmation_number_outlined,
              label: 'Order number',
              value: orderNumber),
          const _Divider(),
          _Row(
              icon: Icons.access_time_rounded,
              label: 'Estimated arrival',
              value: '10 minutes'),
          const _Divider(),
          _Row(
              icon: Icons.location_on_outlined,
              label: 'Delivering to',
              value: 'Berlin, Germany'),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1, color: FlinkColors.midGrey));
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Row(
      {required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: FlinkColors.pink.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: FlinkColors.pink, size: 17),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11,
                      color: FlinkColors.textGrey)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: FlinkColors.black)),
            ],
          ),
        ),
      ],
    );
  }
}

class _LottieDelivery extends StatelessWidget {
  const _LottieDelivery();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 240,
      color: Colors.white,
      child: Lottie.asset(
        'assets/animations/delivery.json',
        fit: BoxFit.contain,
        repeat: true,
        errorBuilder: (context, error, _) => Container(
          height: 240,
          color: const Color(0xFFFCE4F0),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delivery_dining,
                  color: FlinkColors.pink, size: 64),
              SizedBox(height: 8),
              Text(
                'Drop delivery.json in assets/animations/',
                style: TextStyle(
                    color: FlinkColors.textGrey,
                    fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}