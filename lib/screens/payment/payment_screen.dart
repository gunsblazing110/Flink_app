import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../cart/cart_service.dart';
import '../../theme/app_theme.dart';
import 'order_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0; // 0=Card, 1=PayPal, 2=Google Pay, 3=Apple Pay
  final _cardCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _paying = false;

  final CartService _cart = CartService();

  @override
  void dispose() {
    _cardCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirmPay() async {
    if (_selectedMethod == 0 && !_formKey.currentState!.validate()) return;
    setState(() => _paying = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlinkColors.white,
      appBar: AppBar(
        backgroundColor: FlinkColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: FlinkColors.black, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
              color: FlinkColors.black,
              fontWeight: FontWeight.w800,
              fontSize: 18),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: FlinkColors.midGrey),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _OrderSummaryCard(cart: _cart),
            const SizedBox(height: 16),
            _DeliveryAddressCard(),
            const SizedBox(height: 16),
            _sectionTitle('Payment Method'),
            const SizedBox(height: 10),
            _MethodTile(
              index: 0,
              selected: _selectedMethod,
              icon: Icons.credit_card_rounded,
              label: 'Credit / Debit Card',
              subtitle: 'Visa, Mastercard, Amex',
              onTap: () => setState(() => _selectedMethod = 0),
            ),
            const SizedBox(height: 8),
            _MethodTile(
              index: 1,
              selected: _selectedMethod,
              logoWidget: const _PayPalBadge(),
              label: 'PayPal',
              subtitle: 'Pay with your PayPal account',
              onTap: () => setState(() => _selectedMethod = 1),
            ),
            const SizedBox(height: 8),
            _MethodTile(
              index: 2,
              selected: _selectedMethod,
              logoWidget: const _GPayBadge(),
              label: 'Google Pay',
              subtitle: 'Fast & secure checkout',
              onTap: () => setState(() => _selectedMethod = 2),
            ),
            const SizedBox(height: 8),
            _MethodTile(
              index: 3,
              selected: _selectedMethod,
              logoWidget: const _ApplePayBadge(),
              label: 'Apple Pay',
              subtitle: 'Pay with Face ID or Touch ID',
              onTap: () => setState(() => _selectedMethod = 3),
            ),
            // Card fields — animated visibility
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              child: _selectedMethod == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: _CardFields(
                        cardCtrl: _cardCtrl,
                        expiryCtrl: _expiryCtrl,
                        cvvCtrl: _cvvCtrl,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: BoxDecoration(
          color: FlinkColors.white,
          border:
              const Border(top: BorderSide(color: FlinkColors.midGrey, width: 0.8)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -3)),
          ],
        ),
        child: ElevatedButton(
          onPressed: _paying ? null : _confirmPay,
          style: ElevatedButton.styleFrom(
            backgroundColor: FlinkColors.pink,
            disabledBackgroundColor: FlinkColors.midGrey,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: _paying
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5),
                )
              : Text(
                  'Confirm & Pay  €${_cart.grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: FlinkColors.black),
      );
}

// ── Order Summary Card ────────────────────────────────────────────────────────

class _OrderSummaryCard extends StatelessWidget {
  final CartService cart;
  const _OrderSummaryCard({required this.cart});

  @override
  Widget build(BuildContext context) {
    final totalItems =
        cart.items.fold(0, (sum, item) => sum + item.totalItems);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlinkColors.pink.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: FlinkColors.pink.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined,
                  color: FlinkColors.pink, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Order Summary',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: FlinkColors.black,
                    fontSize: 14),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: FlinkColors.pink.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$totalItems items',
                  style: const TextStyle(
                      color: FlinkColors.pink,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SummaryRow(
              label: 'Subtotal',
              value: '€${cart.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 6),
          _SummaryRow(
              label: 'Delivery',
              value: '€${cart.deliveryFee.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: FlinkColors.midGrey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: FlinkColors.black)),
              Text(
                '€${cart.grandTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: FlinkColors.pink),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: FlinkColors.textGrey)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: FlinkColors.black)),
        ],
      );
}

// ── Delivery Address Card ─────────────────────────────────────────────────────

class _DeliveryAddressCard extends StatelessWidget {
  const _DeliveryAddressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FlinkColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: FlinkColors.midGrey),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: FlinkColors.pink.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.location_on, color: FlinkColors.pink, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery Address',
                    style: TextStyle(
                        fontSize: 11, color: FlinkColors.textGrey)),
                SizedBox(height: 2),
                Text('Musterstraße 1, 10115 Berlin',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: FlinkColors.black)),
                Text('Ring the doorbell on arrival',
                    style: TextStyle(
                        fontSize: 11, color: FlinkColors.textGrey)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(44, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: const Text('Change',
                style: TextStyle(
                    color: FlinkColors.pink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ── Payment Method Tile ───────────────────────────────────────────────────────

class _MethodTile extends StatelessWidget {
  final int index;
  final int selected;
  final IconData? icon;
  final Widget? logoWidget;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _MethodTile({
    required this.index,
    required this.selected,
    this.icon,
    this.logoWidget,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selected;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? FlinkColors.pink.withValues(alpha: 0.06)
              : FlinkColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? FlinkColors.pink : FlinkColors.midGrey,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            logoWidget ??
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? FlinkColors.pink.withValues(alpha: 0.12)
                        : FlinkColors.lightGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon,
                      color: isSelected
                          ? FlinkColors.pink
                          : FlinkColors.textGrey,
                      size: 22),
                ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? FlinkColors.black
                              : FlinkColors.textGrey)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11, color: FlinkColors.textGrey)),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? FlinkColors.pink : FlinkColors.textGrey,
                  width: isSelected ? 0 : 1.5,
                ),
                color: isSelected ? FlinkColors.pink : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 13)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Card Fields ───────────────────────────────────────────────────────────────

class _CardFields extends StatelessWidget {
  final TextEditingController cardCtrl;
  final TextEditingController expiryCtrl;
  final TextEditingController cvvCtrl;

  const _CardFields({
    required this.cardCtrl,
    required this.expiryCtrl,
    required this.cvvCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Card Details',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: FlinkColors.black)),
        const SizedBox(height: 10),
        TextFormField(
          controller: cardCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _CardNumberFormatter(),
          ],
          decoration: _inputDecoration(
            'Card Number',
            hint: '1234  5678  9012  3456',
            icon: Icons.credit_card_rounded,
          ),
          validator: (v) {
            if (v == null || v.replaceAll(' ', '').length < 16) {
              return 'Enter a valid 16-digit card number';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: expiryCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ExpiryFormatter(),
                ],
                decoration: _inputDecoration('Expiry', hint: 'MM / YY'),
                validator: (v) =>
                    (v == null || v.length < 5) ? 'Invalid' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: cvvCtrl,
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: _inputDecoration('CVV', hint: '• • •',
                    icon: Icons.lock_outline),
                validator: (v) =>
                    (v == null || v.length < 3) ? 'Invalid' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label,
      {String? hint, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null
          ? Icon(icon, color: FlinkColors.textGrey, size: 20)
          : null,
      filled: true,
      fillColor: FlinkColors.lightGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: FlinkColors.midGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: FlinkColors.midGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: FlinkColors.pink, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}

// ── Input Formatters ──────────────────────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue value) {
    final digits = value.text.replaceAll(' ', '');
    if (digits.length > 16) return old;
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write('  ');
      buf.write(digits[i]);
    }
    final str = buf.toString();
    return value.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue value) {
    final digits = value.text.replaceAll('/', '').replaceAll(' ', '');
    if (digits.length > 4) return old;
    String str = digits;
    if (digits.length >= 3) {
      str = '${digits.substring(0, 2)} / ${digits.substring(2)}';
    } else if (digits.length == 2 && old.text.length == 1) {
      str = '${digits.substring(0, 2)} / ';
    }
    return value.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

// ── Payment Logo Badges ───────────────────────────────────────────────────────

class _PayPalBadge extends StatelessWidget {
  const _PayPalBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Center(
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Pay',
                style: TextStyle(
                  color: Color(0xFF003087),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.3,
                ),
              ),
              TextSpan(
                text: 'Pal',
                style: TextStyle(
                  color: Color(0xFF009CDE),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GPayBadge extends StatelessWidget {
  const _GPayBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, height: 1),
                children: [
                  TextSpan(text: 'G', style: TextStyle(color: Color(0xFF4285F4))),
                  TextSpan(text: 'P', style: TextStyle(color: Color(0xFFEA4335))),
                  TextSpan(text: 'a', style: TextStyle(color: Color(0xFFFBBC05))),
                  TextSpan(text: 'y', style: TextStyle(color: Color(0xFF34A853))),
                ],
              ),
            ),
            const SizedBox(height: 1),
            const Text(
              'Pay',
              style: TextStyle(
                color: Color(0xFF202124),
                fontSize: 7,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplePayBadge extends StatelessWidget {
  const _ApplePayBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomPaint(
            size: const Size(10, 12),
            painter: _AppleIconPainter(),
          ),
          const SizedBox(width: 2),
          const Text(
            'Pay',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Leaf
    final leaf = Path()
      ..moveTo(w * 0.5, h * 0.08)
      ..quadraticBezierTo(w * 0.88, -h * 0.04, w * 0.9, h * 0.24)
      ..quadraticBezierTo(w * 0.55, h * 0.22, w * 0.5, h * 0.08);
    canvas.drawPath(leaf, paint);

    // Apple body
    final body = Path()
      ..moveTo(w * 0.5, h * 0.22)
      ..cubicTo(w * 0.28, h * 0.22, w * 0.04, h * 0.34, w * 0.02, h * 0.58)
      ..cubicTo(0.0, h * 0.80, w * 0.14, h, w * 0.34, h)
      ..cubicTo(w * 0.43, h, w * 0.47, h * 0.93, w * 0.5, h * 0.92)
      ..cubicTo(w * 0.53, h * 0.93, w * 0.57, h, w * 0.66, h)
      ..cubicTo(w * 0.86, h, w, h * 0.80, w * 0.98, h * 0.58)
      ..cubicTo(w * 0.96, h * 0.34, w * 0.72, h * 0.22, w * 0.5, h * 0.22);
    canvas.drawPath(body, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
