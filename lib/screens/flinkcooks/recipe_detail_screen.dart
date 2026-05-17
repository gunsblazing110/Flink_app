import '../cart/cart_service.dart';
import '../cart/cart_screen.dart';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'recipes_data.dart';


class RecipeDetailScreen extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late List<RecipeIngredient> _ingredients;

  @override
  void initState() {
    super.initState();
    _ingredients =
        widget.recipe.ingredients.map((i) => i.copy()).toList();
  }

  double get _totalPrice {
    double total = 0;
    for (final item in _ingredients) {
      if (item.checked) total += item.price * item.qty;
    }
    return total;
  }

  int get _totalItems {
    int total = 0;
    for (final item in _ingredients) {
      if (item.checked) total += item.qty;
    }
    return total;
  }

  void _showAddedToCart() {
    CartService().addRecipe(widget.recipe, _ingredients);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: FlinkColors.white, size: 20),
            SizedBox(width: 10),
            Text(
              'Added to Cart!',
              style: TextStyle(
                  color: FlinkColors.white, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        backgroundColor: FlinkColors.pink,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 88),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlinkColors.white,
      appBar: AppBar(
        backgroundColor: FlinkColors.white,
        elevation: 0.5,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: FlinkColors.lightGrey,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                color: FlinkColors.black, size: 18),
          ),
        ),
        title: Text(
          widget.recipe.name,
          style: const TextStyle(
            color: FlinkColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section — image LEFT, info RIGHT
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.recipe.imageUrl,
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 140,
                          height: 140,
                          color: FlinkColors.lightGrey,
                          child: const Icon(Icons.restaurant,
                              color: FlinkColors.textGrey,
                              size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: FlinkColors.pink
                                  .withOpacity(0.08),
                              borderRadius:
                                  BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.recipe.category,
                              style: const TextStyle(
                                color: FlinkColors.pink,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.recipe.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: FlinkColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.access_time,
                                  size: 14,
                                  color: FlinkColors.textGrey),
                              SizedBox(width: 4),
                              Text(
                                '15 min',
                                style: TextStyle(
                                    color: FlinkColors.textGrey,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.people_outline,
                                  size: 14,
                                  color: FlinkColors.textGrey),
                              SizedBox(width: 4),
                              Text(
                                'Serves 2',
                                style: TextStyle(
                                    color: FlinkColors.textGrey,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '€${_totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: FlinkColors.pink,
                            ),
                          ),
                          const Text(
                            'for all ingredients',
                            style: TextStyle(
                              fontSize: 11,
                              color: FlinkColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(color: FlinkColors.midGrey),
                const SizedBox(height: 16),

                const Text(
                  'About this Recipe',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: FlinkColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.recipe.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: FlinkColors.textGrey,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Cooking Method',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: FlinkColors.black,
                  ),
                ),
                const SizedBox(height: 12),

                ...widget.recipe.steps.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: FlinkColors.pink,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: FlinkColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 14,
                              color: FlinkColors.darkGrey,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 24),
                const Divider(color: FlinkColors.midGrey),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: FlinkColors.black,
                      ),
                    ),
                    Text(
                      '${_ingredients.length} items',
                      style: const TextStyle(
                        fontSize: 13,
                        color: FlinkColors.textGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Untick items you already have at home.',
                  style: TextStyle(
                      fontSize: 12, color: FlinkColors.textGrey),
                ),
                const SizedBox(height: 12),

                ..._ingredients.asMap().entries.map((entry) {
                  return _buildIngredientRow(
                      entry.key, entry.value);
                }),
              ],
            ),
          ),

          // Bottom action bar — Add to Cart + View Cart
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: FlinkColors.white,
                border: Border(
                  top: BorderSide(color: FlinkColors.midGrey, width: 0.8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // ── Add to Cart ──
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _totalItems > 0 ? _showAddedToCart : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlinkColors.pink,
                          disabledBackgroundColor: FlinkColors.midGrey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$_totalItems items',
                              style: const TextStyle(
                                  color: FlinkColors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Text(
                              'Add to Cart',
                              style: TextStyle(
                                  color: FlinkColors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              '€${_totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: FlinkColors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // ── View Cart ──
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const CartScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FlinkColors.black,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined,
                              color: FlinkColors.white, size: 18),
                          SizedBox(height: 2),
                          Text(
                            'View Cart',
                            style: TextStyle(
                                color: FlinkColors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientRow(int index, RecipeIngredient item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: item.checked
            ? FlinkColors.white
            : FlinkColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: FlinkColors.midGrey),
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () {
              setState(() {
                _ingredients[index].checked =
                    !_ingredients[index].checked;
                if (!_ingredients[index].checked) {
                  _ingredients[index].qty = 0;
                } else {
                  _ingredients[index].qty = 1;
                }
              });
            },
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: item.checked
                    ? FlinkColors.pink
                    : FlinkColors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: item.checked
                      ? FlinkColors.pink
                      : FlinkColors.midGrey,
                  width: 1.5,
                ),
              ),
              child: item.checked
                  ? const Icon(Icons.check,
                      color: FlinkColors.white, size: 14)
                  : null,
            ),
          ),

          const SizedBox(width: 10),

          // Name and price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: item.checked
                        ? FlinkColors.black
                        : FlinkColors.textGrey,
                  ),
                ),
                Text(
                  '€${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: item.checked
                        ? FlinkColors.pink
                        : FlinkColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Quantity controls
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_ingredients[index].qty > 1) {
                      _ingredients[index].qty--;
                    } else {
                      _ingredients[index].qty = 0;
                      _ingredients[index].checked = false;
                    }
                  });
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: FlinkColors.midGrey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.remove,
                      size: 16, color: FlinkColors.black),
                ),
              ),
              Container(
                width: 32,
                alignment: Alignment.center,
                child: Text(
                  '${item.qty}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: FlinkColors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _ingredients[index].qty++;
                    _ingredients[index].checked = true;
                  });
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: FlinkColors.pink,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.add,
                      size: 16, color: FlinkColors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}