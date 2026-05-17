import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import 'cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlinkColors.lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _cartService.isEmpty
                  ? _buildEmptyCart()
                  : _buildCartContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: FlinkColors.white,
        border: Border(
          bottom: BorderSide(
              color: FlinkColors.midGrey, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'My Cart',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: FlinkColors.black,
            ),
          ),
          const Spacer(),
          if (!_cartService.isEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  _cartService.clear();
                });
              },
              child: const Text(
                'Clear all',
                style: TextStyle(
                  color: FlinkColors.pink,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: FlinkColors.pink.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: FlinkColors.pink,
              size: 44,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: FlinkColors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Browse Flink Cooks° to add recipes',
            style: TextStyle(
              fontSize: 14,
              color: FlinkColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 160),
          children: [
            ..._cartService.items
                .map((item) => _buildRecipeSection(item)),
            const SizedBox(height: 12),
            _buildSummaryCard(),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            decoration: BoxDecoration(
              color: FlinkColors.white,
              border: Border(
                top: BorderSide(
                    color: FlinkColors.midGrey, width: 0.8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => context.push('/payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlinkColors.pink,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_cartService.items.fold(0, (sum, item) => sum + item.totalItems)} items',
                    style: const TextStyle(
                      color: FlinkColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Proceed to Payment',
                    style: TextStyle(
                      color: FlinkColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '€${_cartService.grandTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: FlinkColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeSection(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: FlinkColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FlinkColors.midGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.recipe.imageUrl,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 52,
                      height: 52,
                      color: FlinkColors.lightGrey,
                      child: const Icon(Icons.restaurant,
                          color: FlinkColors.textGrey,
                          size: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.recipe.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: FlinkColors.black,
                        ),
                      ),
                      Text(
                        item.recipe.category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: FlinkColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _cartService
                          .removeRecipe(item.recipe.name);
                    });
                  },
                  child: const Icon(
                    Icons.delete_outline,
                    color: FlinkColors.textGrey,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
              height: 1, color: FlinkColors.midGrey),
          ...item.selectedIngredients
              .map((ingredient) =>
                  _buildIngredientRow(ingredient)),
          Padding(
            padding:
                const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recipe total',
                  style: TextStyle(
                    fontSize: 13,
                    color: FlinkColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '€${item.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: FlinkColors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientRow(dynamic ingredient) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: FlinkColors.midGrey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: FlinkColors.black,
                  ),
                ),
                Text(
                  '€${ingredient.price.toStringAsFixed(2)} each',
                  style: const TextStyle(
                    fontSize: 11,
                    color: FlinkColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'x${ingredient.qty}',
            style: const TextStyle(
              fontSize: 13,
              color: FlinkColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '€${(ingredient.price * ingredient.qty).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: FlinkColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlinkColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FlinkColors.midGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: FlinkColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal',
                  style: TextStyle(
                      color: FlinkColors.textGrey,
                      fontSize: 14)),
              Text(
                '€${_cartService.subtotal.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: FlinkColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery fee',
                  style: TextStyle(
                      color: FlinkColors.textGrey,
                      fontSize: 14)),
              Text(
                '€${_cartService.deliveryFee.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: FlinkColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: FlinkColors.midGrey),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: FlinkColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '€${_cartService.grandTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: FlinkColors.pink,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.access_time,
                  size: 14, color: FlinkColors.textGrey),
              SizedBox(width: 4),
              Text(
                'Arriving in 10 minutes',
                style: TextStyle(
                  fontSize: 12,
                  color: FlinkColors.textGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}